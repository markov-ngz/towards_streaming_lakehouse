USE CATALOG rest_iceberg ; 

CREATE DATABASE existing_namespace ; 

USE existing_namespace ; 

CREATE TABLE rest_iceberg.existing_namespace.campaign (
  id INT,
  name STRING,
  PRIMARY KEY ( id) NOT ENFORCED
);