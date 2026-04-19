import os 
import argparse
import logging
from flink_sql_gateway_handler import FlinkSqlGateWayHandler



logging.basicConfig(
    filename=".logs",
    level=logging.INFO,
    filemode="a",
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%dT%H:%M:%S",
)
logger = logging.getLogger(__name__)

def parse_args() -> argparse.Namespace :
    parser = argparse.ArgumentParser(
        description="Execute SQL file to remote SQL gateway"
        )
    parser.add_argument(
        "--filepath",
        required=True,
        help="Name of the file to submit",
        )
    
    return parser.parse_args()

def read_file(filepath :str)-> str:

    if not os.path.exists(filepath):
        raise FileNotFoundError("File {0} could not be found ".format(filepath))

    with open(filepath,"r") as f :
        data = f.read()

    return data

def main() -> None:

    # 1. Parse args
    args = parse_args()

    # 2. Extract file path
    filepath = args.filepath

    # 3. Get File content
    file_data = read_file(filepath)

    # 4. Execute the script
    service = FlinkSqlGateWayHandler()
    service.execute_sql_script(file_data)


if __name__ == "__main__":

    main()