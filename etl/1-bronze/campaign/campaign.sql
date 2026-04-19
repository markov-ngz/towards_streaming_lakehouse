-- Synchronize Iceberg table to Fluss tablet's

SET 'execution.mode' = 'kubernetes-session';
SET 'execution.runtime-mode' = 'streaming';


USE CATALOG fluss_iceberg;

USE bronze ; 

CREATE MATERIALIZED TABLE bronze.campaign
FRESHNESS = INTERVAL '10' SECOND 
AS 
    SELECT 
        cast(id as varchar) as campaign_id,
        name as campaign_name
    FROM rest_iceberg.existing_namespace.campaign
;

