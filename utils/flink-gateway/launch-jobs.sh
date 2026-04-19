BASE_PATH=../../../etl


FILES=(
    "1-bronze/campaign.sql"
    "2-silver/first-touch-customer.sql"
    "2-silver/customer-joined-first-touch.sql"
    "3-gold/mart-order-first-touch.sql"
)


for file in "${FILES[@]}"; do

    python3 src/main.py --filepath $BASE_PATH/$file

    if [ $? -ne 0 ]; then
        echo "Error processing $file, stopping execution."
        break;
    fi
done
