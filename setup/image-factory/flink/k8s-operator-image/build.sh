# Extend base k8s operator flink image to add s3 downloading
FLINK_K8S_OPERATOR_IMAGE=flink-s3-k8s-operator:0.1.0
docker build -t $FLINK_K8S_OPERATOR_IMAGE .