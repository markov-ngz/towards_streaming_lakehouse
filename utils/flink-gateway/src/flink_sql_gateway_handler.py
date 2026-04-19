import requests
import time
import logging

logger = logging.getLogger(__name__)


class FlinkSqlGateWayHandler:
    """Handle SQL script submission to flink rest sql gateway"""

    STATEMENT_DELIMITER = ";"
    FETCH_RESULT_DELAY = 5
    SESSION_ENDPOINT = "/v4/sessions"
    OPERATION_ENDPOINT = "/v4/sessions/{session_handle}/statements"
    RESULT_ENDPOINT = "/v4/sessions/{session_handle}/operations/{operation_handle}/result/0"

    session_id: str

    def __init__(self, host: str = "localhost", port: int = 8083) -> None:
        self.base_url = f"http://{host}:{port}"

    def execute_sql_script(self, script_content: str) -> bool:

        # 1. Extract multiple statements
        statements = self.split_statements(script_content)
        logger.info("Starting SQL script execution | statements=%d", len(statements))

        # 2. Open a session 
        self.open_session()

        try:

            # 3. Execute each statement  
            for idx, statement in enumerate(statements, start=1):
                if not statement.strip():
                    continue

                logger.info(
                    "Submitting statement | session=%s | index=%d | sql=%s",
                    self.session_id, idx, statement[:200]
                )

                # 3.1 Submitting statement 
                operation_handle = self.submit_statement(statement)

                logger.info(
                    "Fetching result | session=%s | operation=%s",
                    self.session_id, operation_handle
                )

                # 3.2 Fetching the results 
                result = self.fetch_result(operation_handle)

                logger.info(
                    "Result fetched | session=%s | operation=%s | result=%s",
                    self.session_id, operation_handle,result
                )

        finally:

            # Always close the session 
            self.close_session()
            logger.info("Session closed | session=%s", self.session_id)

        return True

    def split_statements(self, script_content: str) -> list[str]:
        return [
            stmt.strip()
            for stmt in script_content.split(self.STATEMENT_DELIMITER)
            if stmt.strip()
        ]

    def open_session(self) -> None:

        # 1. Construct url 
        url = self.base_url + self.SESSION_ENDPOINT

        # 2. Request the session handler 
        logger.info("Opening session | url=%s", url)
        response = requests.post(url, json={})
        response.raise_for_status()

        # 3. Parse response 
        data = response.json()
        self.session_id = data.get("sessionHandle")

        logger.info("Session opened | session=%s", self.session_id)
        logger.debug("Session response payload: %s", data)

    def submit_statement(self, statement: str) -> str:

        # 1. Build url
        url = self.base_url + self.OPERATION_ENDPOINT.format(
            session_handle=self.session_id
        )


        # 2. Submit statement 
        start = time.time()

        response = requests.post(url, json={"statement": statement})
        response.raise_for_status()

        # 3. Parse response 
        data = response.json()
        operation_handle = data.get("operationHandle")

        duration = time.time() - start

        logger.info(
            "Statement submitted | session=%s | operation=%s | duration=%.2fs",
            self.session_id, operation_handle, duration
        )
        logger.debug("Submit response payload: %s", data)

        return operation_handle

    def fetch_result(self, operation_handle: str) -> dict:
        
        # 1. Build the endpoint 
        next_uri = self.RESULT_ENDPOINT.format(
            session_handle=self.session_id,
            operation_handle=operation_handle
        )

        logger.info(
            "Start fetching results | session=%s | operation=%s",
            self.session_id, operation_handle
        )

        result_data = None
        poll_count = 0

        # 2. Loop while the results needs to be fetched and exit on error
        while next_uri:
            poll_count += 1
            url = self.base_url + next_uri

            logger.debug(
                "Polling result | session=%s | operation=%s | attempt=%d",
                self.session_id, operation_handle, poll_count
            )

            response = requests.get(url)
            data = response.json()

            if "errors" in data:
                logger.error(
                    "Query failed | session=%s | operation=%s | errors=%s",
                    self.session_id, operation_handle, data["errors"]
                )
                raise Exception(
                    f"Query failed {operation_handle}"
                )

            result_data = data
            next_uri = data.get("nextResultUri")

            if next_uri:
                time.sleep(self.FETCH_RESULT_DELAY)

        # 3. If somehow no data could be fetched exit 
        if result_data is None:
            logger.error(
                "No result returned | session=%s | operation=%s",
                self.session_id, operation_handle
            )
            raise ValueError("Could not fetch any result data")

        logger.info(
            "Finished fetching results | session=%s | operation=%s | polls=%d",
            self.session_id, operation_handle, poll_count
        )

        logger.debug("Final result payload: %s", result_data)

        return result_data

    def close_session(self) -> None:

        # 1. Can't close a non existent session
        if not self.session_id:
            return

        # 2. Build the URL
        url = self.base_url + f"{self.SESSION_ENDPOINT}/{self.session_id}"

        logger.info("Closing session | session=%s", self.session_id)

        # 3. Close session 
        response = requests.delete(url)

        if response.status_code >= 400:
            logger.warning(
                "Failed to close session cleanly | session=%s | status=%s",
                self.session_id, response.status_code
            )

        # 4. Reset the session id 
        self.session_id = ""