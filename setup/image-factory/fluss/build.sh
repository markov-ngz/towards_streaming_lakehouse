# Iceberg AWS support (S3FileIO + AWS SDK)
mkdir fluss-libs
curl -fL -o fluss-libs/iceberg-aws-1.10.1.jar https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws/1.10.1/iceberg-aws-1.10.1.jar
curl -fL -o fluss-libs/iceberg-aws-bundle-1.10.1.jar https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws-bundle/1.10.1/iceberg-aws-bundle-1.10.1.jar

# S3 File system
curl -fL -o fluss-libs/fluss-fs-s3-0.9.0-incubating.jar https://repo1.maven.org/maven2/org/apache/fluss/fluss-fs-s3/0.9.0-incubating/fluss-fs-s3-0.9.0-incubating.jar

docker build -t fluss-iceberg-s3:0.9.0 .