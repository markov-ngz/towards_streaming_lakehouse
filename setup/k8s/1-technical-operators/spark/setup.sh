# Download helm to check crds & resources 
helm pull spark-operator \
    --repo https://kubeflow.github.io/spark-operator \
    --untar \
    --untardir ./helm

helm upgrade --install --namespace technical-spark-operator  \
  --set spark.jobNamespaces[0]=spark \
  spark-operator helm/spark-operator