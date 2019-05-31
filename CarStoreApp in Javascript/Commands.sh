docker --version
docker-compose --version


# Go Path
export GOPATH=$HOME/go

# NPM Global modules
PATH="/Users/loonycorn/npm-global/bin:${PATH}"
export PATH


npm install npm@5.6.0 -g
node --version

python --version

# Install Samples, Binaries and Docker Images
curl -sSL http://bit.ly/2ysbOFE | bash -s -- 1.4.1 1.4.1 0.4.15

# clean the keystore
rm -rf ~/.hfc-key-store
docker rm -f $(docker ps -aq)
# docker rmi -f $(docker images -q)

# remove previous crypto material and config transactions
rm -fr config/*
rm -fr crypto-config/*

# generate crypto material
./bin/cryptogen generate --config=./crypto-config.yaml

mkdir config

export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:${PWD}/bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}
CHANNEL_NAME=mychannel

# generate genesis block for orderer
./bin/configtxgen -profile OneOrgOrdererGenesis \
-outputBlock ./config/genesis.block

# generate channel configuration transaction
./bin/configtxgen -profile OneOrgChannel \
-outputCreateChannelTx ./config/channel.tx \
-channelID $CHANNEL_NAME

# generate anchor peer transaction
# It might not be required
# ./bin/configtxgen -profile OneOrgChannel -outputAnchorPeersUpdate ./config/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

# launch network; create channel and join peer to channel
docker-compose -f docker-compose.yml down

# Add FABRIC_CA_SERVER_CA_KEYFILE=<filename of private ca certificate found on location  basiccarstore/crypto-config/peerOrganizations/org1.loonycorn.com/ca>
# Observe the location of chaincode is also changes
docker-compose -f docker-compose.yml up -d ca.loonycorn.com orderer.loonycorn.com peer0.org1.loonycorn.com couchdb
docker ps -a


# Create the channel
MSP_ID="Org1MSP"
MSP_CONFIG_PATH="/etc/hyperledger/msp/users/Admin@org1.loonycorn.com/msp"

docker exec -e "CORE_PEER_LOCALMSPID="$MSP_ID \
-e "CORE_PEER_MSPCONFIGPATH="$MSP_CONFIG_PATH \
peer0.org1.loonycorn.com peer channel create \
-o orderer.loonycorn.com:7050 \
-c mychannel \
-f /etc/hyperledger/configtx/channel.tx

# Join peer0.org1.loonycorn.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID="$MSP_ID \
-e "CORE_PEER_MSPCONFIGPATH="$MSP_CONFIG_PATH \
peer0.org1.loonycorn.com peer channel join \
-b mychannel.block

# Now launch the CLI container in order to install, instantiate chaincode
# and prime the ledger with our 10 cars
docker-compose -f ./docker-compose.yml up -d cli
docker ps -a

cd /opt/gopath/src/github.com

apt-get install vim

vi cars.js
vi package.json

CC_RUNTIME_LANGUAGE=node
CC_SRC_PATH=/opt/gopath/src/github.com/cars/javascript

MSP_ID="Org1MSP"
MSP_CONFIG_PATH="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.loonycorn.com/users/Admin@org1.loonycorn.com/msp"

docker exec -e "CORE_PEER_LOCALMSPID="$MSP_ID \
-e "CORE_PEER_MSPCONFIGPATH="$MSP_CONFIG_PATH \
cli peer chaincode install \
-n carstore \
-v 1.0 \
-p "$CC_SRC_PATH" \
-l "$CC_RUNTIME_LANGUAGE"

docker exec -e "CORE_PEER_LOCALMSPID="$MSP_ID \
-e "CORE_PEER_MSPCONFIGPATH="$MSP_CONFIG_PATH \
cli peer chaincode instantiate \
-o orderer.loonycorn.com:7050 \
-C mychannel \
-n carstore \
-l "$CC_RUNTIME_LANGUAGE" \
-v 1.0 \
-c '{"Args":[]}' -P "OR ('Org1MSP.member','Org2MSP.member')"

sleep 10

docker exec -e "CORE_PEER_LOCALMSPID="$MSP_ID \
-e "CORE_PEER_MSPCONFIGPATH="$MSP_CONFIG_PATH \
cli peer chaincode invoke \
-o orderer.loonycorn.com:7050 \
-C mychannel \
-n carstore \
-c '{"function":"initLedger","Args":[]}'


npm install --save fabric-ca-client@1.4.0 fabric-network@1.4.0

# write all the node files

# curl -H "Content-Type: application/json" -X GET http://localhost:3030/getOneCar -d '{"id": "CAR8"}'

# curl -H "Content-Type: application/json" -X GET http://localhost:3030/addCar -d '{"id":"CAR16","make":"Honda","model":"Accord", "color":"Black", "owner":"Tom"}'
