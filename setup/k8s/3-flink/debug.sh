# Base commands 
kubectl get pods -n flink

kubectl get flinkdeployment -n flink

kubectl describe flinkdeployment -n flink

# Deletion helps 
kubectl delete -f 5-flink-session.yaml

# Force deletion 
kubectl delete flinkdeployment flink-session -n flink --grace-period=0 --force

# as it does not work get finalizer 
kubectl get flinkdeployment flink-session -n flink -o yaml | grep finalizer

# Patch it manually 
kubectl patch flinkdeployment flink-session \
  -n flink \
  --type=merge \
  -p '{"metadata":{"finalizers":[]}}'

kubectl patch flinksessionjob fluss-tiering-job \
  -n flink \
  --type=merge \
  -p '{"metadata":{"finalizers":[]}}'

# Relaunch the gateway dep 
kubectl rollout restart -f 7-flink-sql-gateway.yaml 

# Open SQL client 
POD_NAME=$(kubectl get pod -n flink   -o name | grep flink-session)
echo $POD_NAME
kubectl exec -it $POD_NAME -n flink -- /opt/flink/bin/sql-client.sh