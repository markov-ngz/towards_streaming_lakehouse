POD_NAME=$(kubectl get pods -o jsonpath='{.items[0].metadata.name}' -n polaris)

kubectl logs $POD_NAME -n polaris --tail 200 > .logs