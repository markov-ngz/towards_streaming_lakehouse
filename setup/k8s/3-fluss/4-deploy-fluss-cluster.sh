# Create zookeeper instance 
kubectl apply -f 0-zookeeper

# Configure the values 
helm install fluss ./fluss \
    -f custom-values.yaml \
    --set configurationOverrides.remote\\.data\\.dir=s3://$FLUSS_BUCKET/fluss-remote-data \
    --set configurationOverrides.datalake\\.iceberg\\.credential=$(cat ../1-polaris/client_credentials) \
    --set configurationOverrides.s3\\.access-key=$AWS_ACCESS_KEY_ID \
    --set configurationOverrides.s3\\.secret-key=$AWS_SECRET_ACCESS_KEY \
    -n fluss 
