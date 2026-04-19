
NAMESPACE=polaris #k8s namespace not iceberg's

kubectl config set-context --current --namespace=$NAMESPACE

# 0. Create s3 secrets creds
kubectl apply -f aws-secret.yaml 


# 2. Download helm chart ( it will download latest available version)

# Setup followed at : https://github.com/apache/polaris/tree/release/1.3.x/helm/polaris

helm repo add polaris https://downloads.apache.org/incubator/polaris/helm-chart
helm repo update


mkdir helm
helm pull polaris \
  --repo https://downloads.apache.org/incubator/polaris/helm-chart \
  --devel \
  --untar \
  --untardir ./helm
# devel to handle incubation phase's -incubating suffix

# 3. Configure persistence
# Remove postgres base deployment 
rm helm/polaris/ci/fixtures/postgres.yaml 
# Create polaris db creds used by the API
kubectl apply -f helm/polaris/ci/fixtures/ --namespace $NAMESPACE

# 4. Upgrade chart to use persistent backend
helm upgrade --install --namespace $NAMESPACE \
  -f ./custom-values.yaml \
  --values helm/polaris/ci/persistence-values.yaml \
  polaris helm/polaris

kubectl wait --namespace $NAMESPACE --for=condition=ready pod --selector=app.kubernetes.io/name=polaris --timeout=120s

# 5. Bootstrap database 
kubectl run polaris-bootstrap \
  -n $NAMESPACE \
  --image=apache/polaris-admin-tool:latest \
  --restart=Never \
  --rm -it \
  --env="quarkus.datasource.username=$(kubectl get secret polaris-persistence -n $NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)" \
  --env="quarkus.datasource.password=$(kubectl get secret polaris-persistence -n $NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)" \
  --env="quarkus.datasource.jdbc.url=$(kubectl get secret polaris-persistence -n $NAMESPACE -o jsonpath='{.data.jdbcUrl}' | base64 --decode)" \
  -- \
  bootstrap -r POLARIS -c POLARIS,root,s3cr3t -p