ROOT_REPO_DIR=./../../..
DEPLOY_SCRIPT_DIR=utils/flink-gateway
DEPLOY_SCRIPT=launch-jobs.sh.sh

# Move to dedicated folder holding the application
cd $ROOT_REPO_DIR/$DEPLOY_SCRIPT_DIR

# Execute the script 
./$DEPLOY_SCRIPT