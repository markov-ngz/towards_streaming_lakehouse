docker compose -f 1-flink.docker-compose.yaml up -d
source 2-fluss-tiering-service.sh
source 3-sql-client.sh
