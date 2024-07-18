#!/bin/bash

# Check if node name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <node_name>"
  exit 1
fi

NODE_NAME=$1

# Navigate to /data directory, create if it does not exist
if [ ! -d "/data" ]; then
  sudo mkdir -p /data
fi
cd /data

# Download the backup data
curl -O https://analog-public.s3.amazonaws.com/backup/testnet-backup.tar.gz

# Get the Analog node container ID
CONTAINER_ID=$(sudo docker ps -q --filter ancestor=analoglabs/timechain)

if [ -z "$CONTAINER_ID" ]; then
  echo "No running Analog node container found."
  exit 1
fi

# Stop and remove the old container
sudo docker stop $CONTAINER_ID && sudo docker rm $CONTAINER_ID

# Remove the old chain data
sudo rm -rf /data/chains/analogcc1/paritydb/full

# Extract the backup data
tar -xvzf testnet-backup.tar.gz -C /data

# Pull the new timechain node image
sudo docker pull analoglabs/timenode-test:latest

# Run the new timechain node container
sudo docker run -d -p 9944:9944 -p 30303:30303 --name $NODE_NAME analoglabs/timenode-test:latest --base-path /data --unsafe-rpc-external --rpc-methods=Unsafe --name $NODE_NAME --telemetry-url='wss://telemetry.analog.one/submit 9'

# Monitor the logs to ensure the node is syncing correctly
sudo docker logs -f $NODE_NAME
