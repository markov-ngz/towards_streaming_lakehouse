source ./config.sh
source ./functions/get_token.sh
source ./functions/drop_table.sh

POLARIS_CATALOG=dev_iceberg_datalake_catalog

declare -A NAMESPACES

NAMESPACES[bronze]="intent_event customer"
NAMESPACES[silver]="customer_enriched first_customer_intent"

get_token \
  $POLARIS_HOST \
  $POLARIS_CLIENT_ID \
  $POLARIS_CLIENT_SECRET \
  $POLARIS_CLIENT_SCOPE


for NS in "${!NAMESPACES[@]}"; do
    for TABLE in ${NAMESPACES[$NS]}; do

        echo "🧹 Deleting table: $NS.$TABLE"

        drop_table \
            $POLARIS_TOKEN \
            $POLARIS_CATALOG \
            $NS \
            $TABLE

        echo ""  # newline
    done
done