#!/bin/bash
##############################################################
#Initial Setup script for Corda Network Map
##############################################################
pwd && ls -l notary-info
notaryInfoFileName="$(ls notary-info | grep nodeInfo-)"
echo "creating network-parameters.conf with ${notaryInfoFileNAme}"

# TODO Copy nodeInfo-XXXXXXXXXXXXXXXXXX from the Notary node to here and put it in the network-parameters.conf

cat <<EOF > ./network-parameters.conf
notaries : [
                {
                        notaryNodeInfoFile: nodeInfo-098FC1D752EBE4FF32359C485887D364047EEC717F2A1597394D3994CE02A752
                        validating: false
                }
        ]
        minimumPlatformVersion = 3
        maxMessageSize = 10485760
        maxTransactionSize = 10485760
        eventHorizonDays = 30
EOF

echo "Generated network-parameters.conf"
#java -jar libs/networkmap.jar --config-file network-map.conf
