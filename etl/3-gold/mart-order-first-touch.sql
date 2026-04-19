USE CATALOG fluss_iceberg;

USE gold ;


INSERT INTO gold.mart_order_first_touch
SELECT
    -- sale order fields  
    so.order_id,
    so.customer_id,
    TO_TIMESTAMP(FROM_UNIXTIME(so.order_ts)),
    so.total_amount,

    -- customer fields 
    cf.segment,
    cf.acquisition_channel,

    -- first customer touch
    cf.first_touch_event_id,
    TO_TIMESTAMP(FROM_UNIXTIME(cf.first_touch_event_ts)),
    cf.first_touch_event_type,
    cf.first_touch_campaign_name,

    TO_TIMESTAMP(FROM_UNIXTIME(so.order_ts - cf.first_touch_event_ts)),
    so.ptime

FROM 
    (SELECT sale_order.*, proctime() AS ptime FROM bronze.sale_order) AS so
LEFT JOIN silver.customer_joined_first_touch /*+ OPTIONS('lookup.async' = 'false') */
    FOR SYSTEM_TIME AS OF so.ptime AS cf
ON so.customer_id = cf.customer_id
;