#!/bin/bash
##############################################################
#Initial Setup script for node partyA
##############################################################

NODE_NAME="Node01"
ROOT=../
IDENTITY_MANAGER_DIR=$ROOT/identity-manager
NODE_DIR=$ROOT/$NODE_NAME

##cp $IDENTITY_MANAGER_DIR/trust-stores/network-root-truststore.jks ./
## Copy manually the /trust-stores/network-root-truststore.jks from Identity Manager to here
echo "Copied  $IDENTITY_MANAGER_DIR/trust-stores/network-root-truststore.jks to $NODE_NAME/ directory"

echo "Registering $NODE_NAME with Identity Manager..."
java -jar corda.jar --initial-registration --network-root-truststore-password trustpass --network-root-truststore network-root-truststore.jks