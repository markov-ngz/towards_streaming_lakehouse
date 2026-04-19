
# 1. Add dependencies 
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.18.2/cert-manager.yaml

# 2. Create aws secret 
kubectl apply -f aws-secret.yaml

# 3. Download helm repo locally & 
helm pull flink-kubernetes-operator \
    --repo https://downloads.apache.org/flink/flink-kubernetes-operator-1.14.0/ \
    --untar \
    --untardir ./helm

# 4. Install it 
helm upgrade --install --namespace technical-flink-operator  \
  -f ./custom-values.yaml \
  flink-kubernetes-operator helm/flink-kubernetes-operator

# 5. Check
kubectl get pods -n technical-flink-operator 