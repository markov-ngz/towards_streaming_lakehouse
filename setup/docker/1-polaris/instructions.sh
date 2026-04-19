docker compose -f 1-polaris.docker-compose.yaml up -d
sleep 15 # wait for containers to start
source 2-polaris-bootstrap-catalog.sh
source 3-polaris-create-principal.sh