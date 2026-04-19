docker exec -it spark-master /opt/spark/bin/spark-sql \
  --master spark://spark-master:7077 \
  --jars /opt/spark/extra-jars/iceberg-spark-runtime-4.0_2.13-1.10.1.jar,/opt/spark/extra-jars/iceberg-aws-bundle-1.10.1.jar \
  \
  --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
  \
  --conf spark.sql.catalog.rest=org.apache.iceberg.spark.SparkCatalog \
  --conf spark.sql.catalog.rest.type=rest \
  --conf spark.sql.catalog.rest.uri=http://polaris:8181/api/catalog \
  --conf spark.sql.catalog.rest.auth.type=oauth2 \
  --conf spark.sql.catalog.rest.oauth2-server-uri=http://polaris:8181/api/catalog/v1/oauth/tokens \
  --conf spark.sql.catalog.rest.warehouse=dev_iceberg_datalake_catalog \
  \
  --conf spark.sql.catalog.rest.credential=$(cat ../1-polaris/client_credentials) \
  --conf spark.sql.catalog.rest.scope=PRINCIPAL_ROLE:ALL \
  --conf spark.sql.catalog.rest.token-refresh-enabled=true \
  --conf spark.sql.catalog.rest.header.X-Iceberg-Access-Delegation=vended-credentials