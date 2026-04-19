docker exec -it 3-flink-jobmanager-1 flink run \
    /opt/flink/opt/fluss-flink-tiering-0.9.0-incubating.jar \
        --fluss.bootstrap.servers coordinator-server:9123 \
        --datalake.format iceberg \
        --datalake.iceberg.warehouse dev_iceberg_datalake_catalog \
        --datalake.iceberg.io-impl org.apache.iceberg.aws.s3.S3FileIO \
        --datalake.iceberg.client.region $AWS_REGION \
        --datalake.iceberg.header.X-Iceberg-Access-Delegation vended-credentials \
        --datalake.iceberg.type rest \
        --datalake.iceberg.uri http://polaris:8181/api/catalog \
        --datalake.iceberg.rest.auth.type OAUTH2 \
        --datalake.iceberg.oauth2-server-uri http://polaris:8181/api/catalog/v1/oauth/tokens \
        --datalake.iceberg.credential 0ba0f9eca924fe72:18f97a03c52467f6dcd80fe01b70cd64 \
        --datalake.iceberg.scope PRINCIPAL_ROLE:ALL \
        -D execution.checkpointing.interval=5s
