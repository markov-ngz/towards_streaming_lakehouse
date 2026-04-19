SET 'execution.runtime-mode' = 'batch';
SET 'sql-client.execution.result-mode' = 'tableau';

USE CATALOG rest_iceberg ; 

CREATE DATABASE sandbox;

USE sandbox ; 

-- Select data from previous step 
SELECT * FROM example ;

-- Check basic operation
CREATE TABLE existing_data (
    id INT
);

INSERT INTO existing_data(id) VALUES (123),(456) ; 

SELECT * FROM rest_iceberg.sandbox.existing_data ; 
/*
+-----+
|  id |
+-----+
| 123 |
| 456 |
+-----+
 */
