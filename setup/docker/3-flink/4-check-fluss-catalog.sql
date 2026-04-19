SET 'execution.runtime-mode' = 'batch';
SET 'sql-client.execution.result-mode' = 'tableau';

USE CATALOG fluss_iceberg ;

CREATE DATABASE sandbox ; 

USE sandbox ;

CREATE TABLE sandbox.example (
  id VARCHAR,
  PRIMARY KEY ( id) NOT ENFORCED
) WITH (
    'table.datalake.enabled' = 'true',
    'table.datalake.freshness' = '5s'
);



INSERT INTO example VALUES
  ('A'),
  ('B'),
  ('C');

-- wait for iceberg snapshot  
SELECT * FROM example ; 
/*
Expected result : 

+----+
| id |
+----+
|  A |
|  B |
|  C |
+----+

*/