REALM=POLARIS

ADMIN_CLIENT_ID=root
ADMIN_CLIENT_SECRET=s3cr3t

CATALOG_NAME=dev_iceberg_datalake_catalog
BUCKET_NAME=$ICEBERG_BUCKET # matches fluss and flink datalake config

PRINCIPAL_ROLE_ETL=rf_dev_etl

CATALOG_ROLE_FULL=rt_dev_catalog_full


echo "Obtaining root access token..."
TOKEN_RESPONSE=$(curl --fail-with-body -s -S -X POST http://localhost:8181/api/catalog/v1/oauth/tokens \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -d "grant_type=client_credentials&client_id=${ADMIN_CLIENT_ID}&client_secret=${ADMIN_CLIENT_SECRET}&scope=PRINCIPAL_ROLE:ALL" 2>&1) || {
    echo "❌ Failed to obtain access token"
    echo "$TOKEN_RESPONSE" >&2
    exit 1
}

TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.access_token')
if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
    echo "❌ Failed to parse access token from response"
    echo "$TOKEN_RESPONSE"
    exit 1
fi
echo "✅ Obtained access token"

echo "Creating catalog '$CATALOG_NAME' in realm $REALM..."
PAYLOAD='{
    "catalog": {
    "name": "'$CATALOG_NAME'",
    "type": "INTERNAL",
    "readOnly": false,
    "properties": {
        "default-base-location": "s3://'$BUCKET_NAME'/"
    },
    "storageConfigInfo": {
        "storageType": "S3",
        "allowedLocations": ["s3://'$BUCKET_NAME'/*"],
        "roleArn": "arn:aws:iam::'$AWS_ACCOUNT_ID':role/polaris_vending_role",
        "region": "'$AWS_REGION'"
    }
    }
}'

RESPONSE=$(curl --fail-with-body -s -S -X POST http://localhost:8181/api/management/v1/catalogs \
    -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "Polaris-Realm: $REALM" \
    -d "$PAYLOAD" 2>&1) && echo -n "" || {
    echo "❌ Failed to create catalog"
    echo "$RESPONSE" >&2
    exit 1
}
echo "✅ Catalog created"


echo "Creating principal role $PRINCIPAL_ROLE_ETL..."
RESPONSE=$(curl --fail-with-body -s -S -X POST http://localhost:8181/api/management/v1/principal-roles \
    -H "Authorization: Bearer $TOKEN" \
    -H "Polaris-Realm: $REALM" \
    -H "Content-Type: application/json" \
    -d '{"principalRole": {"name": "'$PRINCIPAL_ROLE_ETL'", "properties": {}}}' 2>&1) && echo -n "" || {
    echo "❌ Failed to create principal role"
    echo "$RESPONSE" >&2
    exit 1
}
echo "✅ Principal role created"

echo "Creating catalog role '$CATALOG_ROLE_FULL'..."
RESPONSE=$(curl --fail-with-body -s -S -X POST http://localhost:8181/api/management/v1/catalogs/$CATALOG_NAME/catalog-roles \
    -H "Authorization: Bearer $TOKEN" \
    -H "Polaris-Realm: $REALM" \
    -H "Content-Type: application/json" \
    -d '{"catalogRole": {"name": "'$CATALOG_ROLE_FULL'", "properties": {}}}' 2>&1) && echo -n "" || {
    echo "❌ Failed to create catalog role"
    echo "$RESPONSE" >&2
    exit 1
}
echo "✅ Catalog role created"



echo "Assigning catalog role to principal role..."
RESPONSE=$(curl --fail-with-body -s -S -X PUT http://localhost:8181/api/management/v1/principal-roles/$PRINCIPAL_ROLE_ETL/catalog-roles/$CATALOG_NAME \
    -H "Authorization: Bearer $TOKEN" \
    -H "Polaris-Realm: $REALM" \
    -H "Content-Type: application/json" \
    -d '{"catalogRole": {"name": "'$CATALOG_ROLE_FULL'"}}' 2>&1) && echo -n "" || {
    echo "❌ Failed to assign catalog role"
    echo "$RESPONSE" >&2
    exit 1
}
echo "✅ Catalog role assigned"

echo "Granting CATALOG_MANAGE_CONTENT privilege to the role ..."
RESPONSE=$(curl --fail-with-body -s -S -X PUT http://localhost:8181/api/management/v1/catalogs/$CATALOG_NAME/catalog-roles/$CATALOG_ROLE_FULL/grants \
    -H "Authorization: Bearer $TOKEN" \
    -H "Polaris-Realm: $REALM" \
    -H "Content-Type: application/json" \
    -d '{"type": "catalog", "privilege": "CATALOG_MANAGE_CONTENT"}' 2>&1) && echo -n "" || {
    echo "❌ Failed to grant privileges"
    echo "$RESPONSE" >&2
    exit 1
}
echo "✅ Privileges granted"