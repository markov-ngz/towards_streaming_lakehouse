source ./config.sh
source ./functions/get_token.sh
source ./functions/drop_table.sh

ICEBERG_NS=bronze # same as fluss database
ICEBERG_TABLE=shop

get_token \
  $POLARIS_HOST \
  $POLARIS_CLIENT_ID \
  $POLARIS_CLIENT_SECRET \
  $POLARIS_CLIENT_SCOPE


drop_table \
  $POLARIS_TOKEN \
  $POLARIS_CATALOG \
  $ICEBERG_NS \
  $ICEBERG_TABLE
  