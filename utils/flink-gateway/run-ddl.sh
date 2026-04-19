BASE_PATH=../../../ddl

FILES=(
    "0-existing-iceberg.sql"
    "1-bronze.sql"
    "2-silver.sql"
    "3-gold.sql"
)


for file in "${FILES[@]}"; do
    python src/main.py --filepath $BASE_PATH/$file

    if [ $? -ne 0 ]; then
        echo "Error processing $file, stopping execution."
        break;
    fi
done
