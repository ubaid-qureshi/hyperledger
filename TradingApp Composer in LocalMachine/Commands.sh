# For Mac
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
nvm current
nvm ls
nvm use --delete-prefix v8.16.0

# Install Docker and VScode
# Install Hyperledger Composer Extension for VSCode
docker --version
docker-compose --version

npm install -g composer-cli@0.20

npm install -g composer-rest-server@0.20

npm install -g generator-hyperledger-composer@0.20

npm install -g yo

npm install -g composer-playground@0.20


curl -O https://raw.githubusercontent.com/hyperledger/composer-tools/master/packages/fabric-dev-servers/fabric-dev-servers.tar.gz
tar -xvf fabric-dev-servers.tar.gz

export FABRIC_VERSION=hlfv12 
./downloadFabric.sh

./startFabric.sh 
./createPeerAdminCard.sh

# Run Following command and details accordingly
yo hyperledger-composer:businessnetwork

cd bank-network

# Generate a business network archive
composer archive create -t dir -n .

composer network install --card PeerAdmin@hlfv1 --archiveFile trading-network@0.0.1.bna

composer network start --networkName trading-network \
--networkVersion 0.0.1 --networkAdmin admin \
--networkAdminEnrollSecret adminpw \
--card PeerAdmin@hlfv1 --file networkadmin.card

composer card import --file networkadmin.card

composer network ping --card admin@trading-network

composer-rest-server

yo hyperledger-composer:angular

