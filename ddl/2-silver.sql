USE CATALOG fluss_iceberg ; 

CREATE DATABASE silver ; 
USE silver ; 


CREATE TABLE silver.first_customer_touch_event (
    customer_id STRING,
    event_id STRING,
    event_type STRING,
    campaign_name STRING,
    event_ts BIGINT,
    PRIMARY KEY (customer_id) NOT ENFORCED
) WITH (
    'table.merge-engine' = 'first_row'
);

CREATE TABLE silver.customer_joined_first_touch (
    customer_id STRING,
    email STRING,
    phone STRING,
    segment STRING,
    acquisition_channel STRING,
    last_purchase_ts BIGINT,
    country STRING,
    opt_in BOOLEAN,
     
    first_touch_event_type STRING,
    first_touch_event_id   STRING,
    first_touch_campaign_name STRING,
    first_touch_event_ts BIGINT,
    PRIMARY KEY (customer_id) NOT ENFORCED
);