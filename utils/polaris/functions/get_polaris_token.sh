get_token() {
    local catalog_host="$1"
    local client_id="$2"
    local client_secret="$3"
    local scope="$4"

    token_response=$(curl --fail-with-body -s -S -X POST http://$catalog_host/api/catalog/v1/oauth/tokens \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -d "grant_type=client_credentials&client_id=${client_id}&client_secret=${client_secret}&scope=${scope}" 2>&1) || {
        echo "❌ Failed to obtain access token"
        echo "$token_response" >&2
        exit 1
    }

    POLARIS_TOKEN=$(echo $token_response | jq -r '.access_token')

    if [ -z "$POLARIS_TOKEN" ] || [ "$POLARIS_TOKEN" = "null" ]; then
        echo "❌ Failed to parse access token from response"
        echo "$token_response"
        exit 1
    fi
}