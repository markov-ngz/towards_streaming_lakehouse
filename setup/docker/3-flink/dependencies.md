List of dependencies needed for the Flink Cluster
```sh
flink
├── 2-2-lib
│   ├── failsafe-3.3.2.jar
│   ├── flink-s3-fs-hadoop-2.2.0.jar
│   ├── fluss-flink-2.2-0.9.0-incubating.jar
│   ├── fluss-fs-s3-0.9.0-incubating.jar
│   ├── fluss-lake-iceberg-0.9.0-incubating.jar
│   ├── hadoop-client-api-3.3.5.jar
│   ├── hadoop-client-runtime-3.3.5.jar
│   ├── iceberg-aws-bundle-1.10.1.jar
│   ├── iceberg-flink-1.10.1.jar
│   └── iceberg-flink-runtime-2.0-1.10.1.jar
├── 2-2-opt
│   └── fluss-flink-tiering-0.9.0-incubating.jar
└── catalog-store
    ├── dev_iceberg_datalake_catalog.yaml
    └── rest_iceberg.yaml
```