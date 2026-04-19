USE CATALOG fluss_iceberg ; 

CREATE DATABASE gold ; 

USE gold ;


CREATE TABLE gold.mart_order_first_touch (
    order_id                                 STRING,   
    customer_id                              STRING,
    order_timestamp                          TIMESTAMP,       
    total_amount                             DECIMAL,
    
    customer_segment                         STRING,    
    customer_acquisition_channel             STRING,          
    
    -- first  customer touch
    first_touch_event_id                     STRING,
    first_touch_timestamp                    TIMESTAMP,
    first_touch_event_type                   STRING,
    first_touch_campaign_name                STRING,       
    
    delta_first_touch_to_order               TIMESTAMP,    
    
    _tech_write_ts                           TIMESTAMP,
    PRIMARY KEY (order_id) NOT ENFORCED
) WITH(
    'table.datalake.enabled' = 'true',
    'table.datalake.freshness' = '30s'
)
;