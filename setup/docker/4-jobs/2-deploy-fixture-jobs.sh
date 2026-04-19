JAR_NAME=generate-fake-data-0.1.0.jar
JAR_PATH=./../../../etl/1-bronze/generate-fake-data/target
FLINK_JOBMANAGER=3-flink-jobmanager-1
FLINK_JOBDIR=/opt/flink/usrlib

docker exec $FLINK_JOBMANAGER mkdir $FLINK_JOBDIR

docker cp $JAR_PATH/$JAR_NAME $FLINK_JOBMANAGER:$FLINK_JOBDIR

docker exec -it $FLINK_JOBMANAGER flink run -d \
    $FLINK_JOBDIR/$JAR_NAME \
        --pipeline.name bronze-ingest-events \
        --entity event \
        --fluss.bootstrap.servers coordinator-server:9123 \
        --sink.fluss.database bronze \
        --sink.fluss.table event 

docker exec -it $FLINK_JOBMANAGER flink run -d \
    $FLINK_JOBDIR/$JAR_NAME \
        --pipeline.name bronze-ingest-sale-orders \
        --entity sale_order \
        --fluss.bootstrap.servers coordinator-server:9123 \
        --sink.fluss.database bronze \
        --sink.fluss.table sale_order 

docker exec -it $FLINK_JOBMANAGER flink run -d \
    $FLINK_JOBDIR/$JAR_NAME \
        --pipeline.name bronze-ingest-customer\
        --entity customer \
        --fluss.bootstrap.servers coordinator-server:9123 \
        --sink.fluss.database bronze \
        --sink.fluss.table customer 