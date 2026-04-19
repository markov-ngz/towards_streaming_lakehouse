CLIENT_ID=80237567e775c9ce
CLIENT_SECRET=d43ccb716447b2dce839a36effb16ecc

curl -X POST "http://localhost:8181/api/catalog/v1/oauth/tokens" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "scope=PRINCIPAL_ROLE:ALL"
# ADMIN_CLIENT_ID=root
# ADMIN_CLIENT_SECRET=s3cr3t

# curl  -s -X DELETE http://localhost:8181/api/management/v1/principals/fluss_user \
#     -H "Content-Type: application/x-www-form-urlencoded" \
#     -d "grant_type=client_credentials&client_id'$ADMIN_CLIENT_ID'=&client_secret='$ADMIN_CLIENT_SECRET'&scope=PRINCIPAL_ROLE:ALL"