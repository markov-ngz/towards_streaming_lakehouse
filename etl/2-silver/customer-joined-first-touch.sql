USE CATALOG fluss_iceberg;


USE silver ; 


INSERT INTO silver.customer_joined_first_touch
SELECT
    c.customer_id,
    c.email,
    c.phone,
    c.segment,
    c.acquisition_channel,
    c.last_purchase_ts,
    c.country,
    c.opt_in,

    fct.event_type,
    fct.event_id,
    fct.campaign_name,
    fct.event_ts

FROM silver.first_customer_touch_event fct
JOIN bronze.customer c
ON fct.customer_id = c.customer_id
;