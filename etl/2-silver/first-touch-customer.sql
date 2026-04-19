USE CATALOG fluss_iceberg;

USE silver; 

INSERT INTO silver.first_customer_touch_event
SELECT
    ie.customer_id,
    ie.event_id,
    ie.event_type,
    camp.campaign_name,
    ie.event_ts
FROM bronze.event ie 
LEFT JOIN bronze.campaign camp
    ON camp.campaign_id = ie.campaign_id;