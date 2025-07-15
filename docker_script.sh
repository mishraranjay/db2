 #!/bin/bash


# Assume the first argument is the sample flag (e.g. true/false)
sampledb=$1
#Extract value from sampledb=true
sampledb_v=$(echo "$1" | cut -d '=' -f2)
echo "🏗️  SampleDB: $sampledb_v"


 # Hardcoded image details
IMAGE_NAME="db2"
IMAGE_TAG="latest"
CONTAINER_NAME="c-db2"

# Check if the container '$CONTAINER_NAME' exists and stop it if it does
if [ "$(docker ps -aq -f name=CONTAINER_NAME)" ]; then
    echo "Stopping existing container '$CONTAINER_NAME'..."
    docker stop $CONTAINER_NAME
fi

# Check if the container $CONTAINER_NAME' exists and remove it if it does
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Removing existing container '$CONTAINER_NAME'..."
    docker rm -f $CONTAINER_NAME
fi


# Construct full image name
FULL_IMAGE_NAME="$IMAGE_NAME:$IMAGE_TAG"

echo "🏗️  Building Docker image: $FULL_IMAGE_NAME"
docker build -t "$FULL_IMAGE_NAME" .

read -s -p "🔒  Set the password for the DB2 user: " DB2_PASSWORD
echo

# Run the Docker container
echo "Running the Docker container ..."

if [ "$sampledb_v" = "true" ]; then
    echo "🧪 Launching container with sample DB..."
    docker run -itd --name $CONTAINER_NAME --privileged=true -p 50000:50000 \
    -e LICENSE=accept \
    -e DB2INST1_PASSWORD=$DB2_PASSWORD \
    -e SAMPLEDB=true \
    $IMAGE_NAME
else
    echo "🚀 Launching standard container with defined DB..."
    docker run -itd --name $CONTAINER_NAME --privileged=true -p 50000:50000 \
    -e LICENSE=accept \
    -e DB2INST1_PASSWORD=$DB2_PASSWORD \
    -e DBNAME=testdb \
    $IMAGE_NAME
fi
