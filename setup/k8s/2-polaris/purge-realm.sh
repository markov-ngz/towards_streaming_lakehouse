NAMESPACE=polaris
REALM=POLARIS

kubectl run polaris-purge \
  -n $NAMESPACE \
  --image=apache/polaris-admin-tool:latest \
  --restart=Never \
  --rm -it \
  --env="quarkus.datasource.username=$(kubectl get secret polaris-persistence -n $NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)" \
  --env="quarkus.datasource.password=$(kubectl get secret polaris-persistence -n $NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)" \
  --env="quarkus.datasource.jdbc.url=$(kubectl get secret polaris-persistence -n $NAMESPACE -o jsonpath='{.data.jdbcUrl}' | base64 --decode)" \
  -- \
  purge -r $REALM