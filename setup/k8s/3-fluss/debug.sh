# Steps followed at :  https://fluss.apache.org/docs/next/install-deploy/deploying-with-helm/

export NAMESPACE=fluss

kubectl config set-context --current --namespace=$NAMESPACE

kubectl apply -f ./0-zookeeper/

kubectl get pods -n fluss
kubectl exec -n fluss deploy/zookeeper -- zkServer.sh status