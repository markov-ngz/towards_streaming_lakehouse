# Ressources Cloud

Create the 3 following buckets with a user having rw access on it : 
- flink : checkpoint , savepoint and deployment jars ( pulled by k8s operator pod )
- fluss : for key store
- iceberg : the datalake files ( metadata (.avro & .json) and .parquet )



**NOTES**
As it is a solo project, to ease up , only one user and role are created with full grants on specified buckets.
For real case, it is strongly advised to create 3 users with specified roles over the bucket ( r / w ).


