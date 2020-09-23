#!/bin/bash

echo "Stop and remove Docker images and containers..."
docker-compose -f docker-compose-deploy.yaml down -v && docker rmi $(docker images | grep 'cenm') && docker rm $(docker ps | grep 'cenm')

echo "## Clean all artifacts..."
cd identity-manager && rm -rf key-stores logs shell-commands ssh trust-stores *.jks *.db
cd ../network-map && rm -rf logs shell-commands ssh *.db
cd ../node01 && rm -rf brokers additional-node-infos artemis broker certificates cordapps djvm logs shell-commands ssh network-parameters nodeInfo* *.db process-id
cd ../notary && rm -rf brokers additional-node-infos artemis broker certificates cordapps djvm logs shell-commands ssh network-parameters nodeInfo* *.db process-id
cd ../angel && rm -rf logs *.db
cd ../auth && rm -rf logs 
cd ../farm && rm -rf logs 
cd ../zone && rm -rf logs *.db
echo "Artifacts cleaned up!"