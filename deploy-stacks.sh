#!/bin/bash
# deploy-stacks.sh

# Define the directories for the stacks
PORTAINER_DIR="portainer/docker-compose.yml"
PIHOLE_DIR="pi-hole/docker-compose.yml"

# Function to deploy a stack
deploy_stack() {
    local stack_dir=$1
    if [ -f $stack_dir ]; then
        echo "Deploying stack from: $stack_dir"
        docker compose -f $stack_dir up -d
        echo "Deployment of stack from $stack_dir completed."
    else
        echo "Error: $stack_dir does not exist."
    fi
}

# Deploy Portainer
echo "Deploying Portainer..."
deploy_stack $PORTAINER_DIR

# Deploy Pi-hole
echo "Deploying Pi-hole..."
deploy_stack $PIHOLE_DIR

echo "All stacks deployed successfully!"