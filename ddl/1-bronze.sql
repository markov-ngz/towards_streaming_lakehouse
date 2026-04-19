USE CATALOG fluss_iceberg ; 

CREATE DATABASE bronze ; 

USE bronze; 


CREATE TABLE bronze.event (
    event_id STRING,
    customer_id STRING,
    event_type STRING,
    campaign_id STRING,
    event_ts BIGINT,
    PRIMARY KEY (event_id) NOT ENFORCED
) WITH (    
    'table.datalake.enabled' = 'true',
    'table.datalake.freshness' = '30s',
    'iceberg.overwrite-enabled' = 'true'
);


CREATE TABLE bronze.customer (
    customer_id STRING,
    email STRING,
    phone STRING,
    segment STRING,
    acquisition_channel STRING,
    country STRING,
    opt_in BOOLEAN,
    last_purchase_ts BIGINT,
    PRIMARY KEY (customer_id) NOT ENFORCED
) WITH (
    'table.delete.behavior' = 'IGNORE',
    'table.datalake.enabled' = 'true',
    'table.datalake.freshness' = '30s'
);



CREATE TABLE bronze.sale_order (
    order_id STRING,
    customer_id STRING,
    total_amount DECIMAL(10, 2),
    order_ts BIGINT,
    PRIMARY KEY (order_id) NOT ENFORCED
)WITH(
    'table.datalake.enabled' = 'true',
    'table.datalake.freshness' = '30s'
);