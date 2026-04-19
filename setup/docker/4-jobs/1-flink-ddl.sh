ROOT_REPO_DIR=./../../..
DDL_SCRIPT_DIR=utils/flink-gateway
DDL_SCRIPT=run-ddl.sh

# Move to dedicated folder holding the application
cd $ROOT_REPO_DIR/$DDL_SCRIPT_DIR

# Run it 
./$DDL_SCRIPT