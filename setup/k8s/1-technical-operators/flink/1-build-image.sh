# Move to folder where to build the image
cd ./../../../image-factory/flink/k8s-operator-image

# Download the specified jar
cat .flink-libs

# Build the image
./build.sh
