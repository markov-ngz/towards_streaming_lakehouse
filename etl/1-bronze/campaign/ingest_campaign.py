import os
from pyspark.sql import SparkSession

# Polaris Credential
catalog_credential = os.environ["ICEBERG_CATALOG_CREDENTIAL"]

spark = (
    SparkSession.builder
    .appName("ingest-campaign")
    .config("spark.sql.catalog.rest.credential", catalog_credential)
    .getOrCreate()
    # All other config is already injected via sparkConf in the CRD
)

spark.sql("""
    INSERT INTO rest.existing_namespace.campaign (id, name)
    VALUES
        (1, 'Summer Sale 2026 - 50% Off'),
        (2, 'Black Friday Early Access - Limited Stock')
""")

spark.stop()