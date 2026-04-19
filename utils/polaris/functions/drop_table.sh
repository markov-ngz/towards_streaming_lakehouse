drop_table(){
    local token="$1"
    local catalog="$2"
    local iceberg_ns="$3"
    local iceberg_table="$4"


    curl -X DELETE "http://localhost:8181/api/catalog/v1/$catalog/namespaces/$iceberg_ns/tables/$iceberg_table" \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json"
}