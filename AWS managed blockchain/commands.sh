### IAM Policy

{
    "Version": "2012-10-17",
    "Statement":[{
    "Effect":"Allow",
    "Action":"ec2:*VpcEndpoint*",
    "Resource":"*"
    }
  ]
}


### Security Group 

HFClientAndEndpoint

chmod 400 org1-key.pem


sudo yum update -y
sudo yum install -y telnet
sudo yum -y install emacs
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

sudo curl -L \
https://github.com/docker/compose/releases/download/1.20.0/docker-compose-`uname \
-s`-`uname -m` -o /usr/local/bin/docker-compose

sudo chmod a+x /usr/local/bin/docker-compose
sudo yum install libtool -y

wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
tar -xzf go1.10.3.linux-amd64.tar.gz
sudo mv go /usr/local
sudo yum install libtool-ltdl-devel -y
sudo yum install git -y

nano ~/.bash_profile

# GOROOT is the location where Go package is installed on your system
export GOROOT=/usr/local/go

# GOPATH is the location of your work directory
export GOPATH=$HOME/go

# Update PATH so that you can access the go binary system wide
export PATH=$GOROOT/bin:$PATH
export PATH=$PATH:/home/ec2-user/go/src/github.com/hyperledger/fabric-ca/bin

source ~/.bash_profile

sudo docker version
sudo /usr/local/bin/docker-compose version
go version

aws --version
which aws
cd /usr/bin/
sudo rm -rf aws
cd 

curl -O https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py --user # or python3

sudo pip install --upgrade --user awscli

sudo pip install --upgrade awscli
sudo cp -R  ~/.local/bin/aws* /usr/bin/


aws managedblockchain get-member \
--network-id n-G5LHNJ5RXFDHLPYTGUZTYLBWDQ \
--member-id m-5KNKUTNB4FBMRHDZNHN22UB4WA \
--region us-east-1

telnet https://ca.m-5knkutnb4fbmrhdznhn22ub4wa.n-g5lhnj5rxfdhlpytguztylbwdq.managedblockchain.us-east-1.amazonaws.com 30002


go get -u github.com/hyperledger/fabric-ca/cmd/...
cd /home/ec2-user/go/src/github.com/hyperledger/fabric-ca
git fetch
git checkout release-1.2
make fabric-ca-client


cd /home/ec2-user
git clone https://github.com/loonyuser/carstore.git


nano docker-compose-cli.yaml
docker-compose -f docker-compose-cli.yaml up -d

docker ps

aws s3 cp s3://us-east-1.managedblockchain/etc/managedblockchain-tls-chain.pem  \
/home/ec2-user/managedblockchain-tls-chain.pem
# cd managedblockchain-tls-chain.pem
openssl x509 -noout -text -in managedblockchain-tls-chain.pem
# cd ..

# mv managedblockchain-tls-chain.pem managedblockchain-tls-chain.pem_dir
# mv managedblockchain-tls-chain.pem_dir/managedblockchain-tls-chain.pem .
# rm -rf managedblockchain-tls-chain.pem_dir


fabric-ca-client enroll \
-u https://Org1Admin:Org1Admin@ca.m-5knkutnb4fbmrhdznhn22ub4wa.n-g5lhnj5rxfdhlpytguztylbwdq.managedblockchain.us-east-1.amazonaws.com:30002 \
--tls.certfiles /home/ec2-user/managedblockchain-tls-chain.pem -M /home/ec2-user/admin-msp

ls admin-msp/*
cp -r admin-msp/signcerts admin-msp/admincerts
ls admin-msp/*


# ## Add peers
# aws managedblockchain create-node \
# --node-configuration '{"InstanceType":"bc.t3.small","AvailabilityZone":"us-east-1a"}' \
# --network-id n-U5TOQXCE7VAGHFWOW44R6HIZ3A \
# --member-id m-EBAS6UBB65BHJIBTARQMSRPBQY


docker exec cli configtxgen \
-outputCreateChannelTx /opt/home/channel1.pb \
-profile OneOrgChannel -channelID channel1 \
--configPath /opt/home/

# in bash
export MSP_PATH=/opt/home/admin-msp
export MSP=m-EBAS6UBB65BHJIBTARQMSRPBQY
export ORDERER=orderer.n-u5toqxce7vaghfwow44r6hiz3a.managedblockchain.us-east-1.amazonaws.com:30001
export PEER=nd-jqr6mvmagbfknhswdr45ldxnn4.m-ebas6ubb65bhjibtarqmsrpbqy.n-u5toqxce7vaghfwow44r6hiz3a.managedblockchain.us-east-1.amazonaws.com:30009

docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer channel create -c channel1 \
-f /opt/home/channel1.pb -o $ORDERER \
--cafile /opt/home/managedblockchain-tls-chain.pem --tls

docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer channel join -b channel1.block \
-o $ORDERER --cafile /opt/home/managedblockchain-tls-chain.pem --tls



docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
-e "CORE_PEER_ADDRESS=$PEER" \
cli peer chaincode install \
-n mycc -v v0 -p github.com/go

docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
-e "CORE_PEER_ADDRESS=$PEER" \
cli peer chaincode instantiate \
-o $ORDERER -C channel1 -n mycc -v v0 \
-c '{"Args":[]}' \
--cafile /opt/home/managedblockchain-tls-chain.pem --tls

docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e  "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
-e "CORE_PEER_ADDRESS=$PEER"  \
cli peer chaincode list --instantiated \
-o $ORDERER -C channel1 \
--cafile /opt/home/managedblockchain-tls-chain.pem --tls

docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER"  -e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer chaincode invoke -C channel1 \
-n mycc -c  '{"function":"initLedger","Args":[]}' \
-o $ORDERER --cafile /opt/home/managedblockchain-tls-chain.pem --tls

docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer chaincode query -C channel1 \
-n mycc -c '{"Args":["queryAllCars"]}'

docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER"  -e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer chaincode invoke -C channel1 \
-n mycc -c  '{"function":"createCar","Args":["CAR10", "Toyota", "Prius", "Black", "Alice"]}' \
-o $ORDERER --cafile /opt/home/managedblockchain-tls-chain.pem --tls


# User 1 -- > 236912928450 
# User 2 -- > 


aws managedblockchain get-member \
--network-id n-G5LHNJ5RXFDHLPYTGUZTYLBWDQ \
--member-id m-XP7QCLM4BVHUBN3V2KYCRR67SY \
--region us-east-1

curl ca.m-xp7qclm4bvhubn3v2kycrr67sy.n-g5lhnj5rxfdhlpytguztylbwdq.managedblockchain.us-east-1.amazonaws.com:30005/cainfo -k


go get -u github.com/hyperledger/fabric-ca/cmd/...
cd /home/ec2-user/go/src/github.com/hyperledger/fabric-ca
git fetch
git checkout release-1.2
make fabric-ca-client


cd /home/ec2-user
git clone https://github.com/loonyuser/carstore.git


nano docker-compose-cli.yaml
docker-compose -f docker-compose-cli.yaml up -d

docker ps

aws s3 cp s3://us-east-1.managedblockchain/etc/managedblockchain-tls-chain.pem  \
/home/ec2-user/managedblockchain-tls-chain.pem
# cd managedblockchain-tls-chain.pem
openssl x509 -noout -text -in managedblockchain-tls-chain.pem
# cd ..

# mv managedblockchain-tls-chain.pem managedblockchain-tls-chain.pem_dir
# mv managedblockchain-tls-chain.pem_dir/managedblockchain-tls-chain.pem .
# rm -rf managedblockchain-tls-chain.pem_dir


fabric-ca-client enroll \
-u https://Org2Admin:Org2Admin@ca.m-xp7qclm4bvhubn3v2kycrr67sy.n-g5lhnj5rxfdhlpytguztylbwdq.managedblockchain.us-east-1.amazonaws.com:30005 \
--tls.certfiles /home/ec2-user/managedblockchain-tls-chain.pem -M /home/ec2-user/admin-msp

ls admin-msp/*
cp -r admin-msp/signcerts admin-msp/admincerts
ls admin-msp/*

#### Add Peers

ca-m-xp7qclm4bvhubn3v2kycrr67sy-n-g5lhnj5rxfdhlpytguztylbwdq-managedblockchain-us-east-1-amazonaws-com-30005.pem
##############
#### Go to Org1

mkdir /home/ec2-user/org2-msp
mkdir /home/ec2-user/org2-msp/admincerts
mkdir /home/ec2-user/org2-msp/cacerts

cp Org2AdminCerts /home/ec2-user/org2-msp/admincerts
cp Org2CACerts /home/ec2-user/org2-msp/cacerts

aws managedblockchain list-members \
--network-id n-G5LHNJ5RXFDHLPYTGUZTYLBWDQ \
--region us-east-1

{
    "Members": [
        {
            "Id": "m-EBAS6UBB65BHJIBTARQMSRPBQY",
            "Name": "member1",
            "Status": "AVAILABLE",
            "CreationDate": "2019-05-10T09:04:06.163Z",
            "IsOwned": true
        },
        {
            "Id": "m-WZSUAKIZO5G23OFSFUROPKA3SY",
            "Name": "member2",
            "Status": "AVAILABLE",
            "CreationDate": "2019-05-12T11:28:17.991Z",
            "IsOwned": false
        }
    ]
}

cat configtx.yaml 

rm -rf configtx.yaml 

nano configtx.yaml 

docker exec cli configtxgen \
-outputCreateChannelTx /opt/home/ourchannel.pb \
-profile TwoOrgChannel -channelID ourchannel \
--configPath /opt/home/


docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer channel create -c ourchannel \
-f /opt/home/ourchannel.pb -o $ORDERER \
--cafile /opt/home/managedblockchain-tls-chain.pem --tls



# Run this in second instance

## Now in second instance 
export MSP_PATH=/opt/home/admin-msp
export MSP=m-XP7QCLM4BVHUBN3V2KYCRR67SY
export ORDERER=orderer.n-g5lhnj5rxfdhlpytguztylbwdq.managedblockchain.us-east-1.amazonaws.com:30001
export PEER=nd-qqoeixucazb3tcnvxus2peff7a.m-xp7qclm4bvhubn3v2kycrr67sy.n-g5lhnj5rxfdhlpytguztylbwdq.managedblockchain.us-east-1.amazonaws.com:30006


docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER" \
-e "CORE_PEER_LOCALMSPID=$MSP" -e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer channel fetch oldest /opt/home/ourchannel.block \
-c ourchannel -o $ORDERER \
--cafile /opt/home/managedblockchain-tls-chain.pem --tls


## Now in both run following comands

docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer channel join -b /opt/home/ourchannel.block \
-o $ORDERER --cafile /opt/home/managedblockchain-tls-chain.pem --tls


docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
-e "CORE_PEER_ADDRESS=$PEER" \
cli peer chaincode install  -n mycc -v v0 \
-p github.com/go



# Now in org1 run this
docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e  "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
-e "CORE_PEER_ADDRESS=$PEER" \
cli peer chaincode instantiate -o $ORDERER \
-C ourchannel -n mycc -v v0 \
-c '{"Args":[]}'  \
--cafile /opt/home/managedblockchain-tls-chain.pem --tls \
-P "AND ('m-5KNKUTNB4FBMRHDZNHN22UB4WA.member','m-XP7QCLM4BVHUBN3V2KYCRR67SY.member')"


docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer chaincode invoke \
-C ourchannel -n mycc -c  '{"function":"initLedger","Args":[]}' \
--peerAddresses $PEER \
--tlsRootCertFiles /opt/home/managedblockchain-tls-chain.pem \
--peerAddresses nd-qqoeixucazb3tcnvxus2peff7a.m-xp7qclm4bvhubn3v2kycrr67sy.n-g5lhnj5rxfdhlpytguztylbwdq.managedblockchain.us-east-1.amazonaws.com:30006 \
--tlsRootCertFiles /opt/home/managedblockchain-tls-chain.pem \
-o $ORDERER --cafile /opt/home/managedblockchain-tls-chain.pem --tls



clear 

docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer chaincode query -C ourchannel \
-n mycc -c '{"function":"queryAllCars","Args":[]}'




docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer chaincode invoke \
-C ourchannel -n mycc -c '{"function":"createCar","Args":["CAR10", "Tesla", "S", "Black", "Bob"]}' \
--peerAddresses $PEER \
--tlsRootCertFiles /opt/home/managedblockchain-tls-chain.pem \
--peerAddresses nd-qqoeixucazb3tcnvxus2peff7a.m-xp7qclm4bvhubn3v2kycrr67sy.n-g5lhnj5rxfdhlpytguztylbwdq.managedblockchain.us-east-1.amazonaws.com:30006 \
--tlsRootCertFiles /opt/home/managedblockchain-tls-chain.pem \
-o $ORDERER --cafile /opt/home/managedblockchain-tls-chain.pem --tls



docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer chaincode query -C ourchannel \
-n mycc -c '{"function":"queryAllCars","Args":[]}'




docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer chaincode invoke \
-C ourchannel -n mycc -c '{"function":"createCar","Args":["CAR11", "Peugeot", "205", "purple", "Smith"]}' \
--peerAddresses $PEER \
--tlsRootCertFiles /opt/home/managedblockchain-tls-chain.pem \
--peerAddresses nd-cl22ujfdafejlluj3jd2rfafti.m-5knkutnb4fbmrhdznhn22ub4wa.n-g5lhnj5rxfdhlpytguztylbwdq.managedblockchain.us-east-1.amazonaws.com:30003 \
--tlsRootCertFiles /opt/home/managedblockchain-tls-chain.pem \
-o $ORDERER --cafile /opt/home/managedblockchain-tls-chain.pem --tls




docker exec -e "CORE_PEER_TLS_ENABLED=true" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
-e "CORE_PEER_ADDRESS=$PEER" \
-e "CORE_PEER_LOCALMSPID=$MSP" \
-e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
cli peer chaincode query -C ourchannel \
-n mycc -c '{"function":"queryAllCars","Args":[]}'



		# Car{Make: "", Model: "S", Colour: "black", Owner: "Adriana"},
		# Car{Make: "Peugeot", Model: "205", Colour: "purple", Owner: "Michel"},
		# Car{Make: "Chery", Model: "S22L", Colour: "white", Owner: "Aarav"},




# docker exec -e "CORE_PEER_TLS_ENABLED=true" \
# -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
# -e "CORE_PEER_LOCALMSPID=$MSP" \
# -e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
# -e "CORE_PEER_ADDRESS=$PEER" \
# cli peer chaincode instantiate \
# -o $ORDERER -C channel1 -n mycc -v v0 \
# \
# --cafile /opt/home/managedblockchain-tls-chain.pem --tls

# docker exec -e "CORE_PEER_TLS_ENABLED=true" \
# -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
# -e "CORE_PEER_LOCALMSPID=$MSP" \
# -e  "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
# -e "CORE_PEER_ADDRESS=$PEER"  \
# cli peer chaincode list --instantiated \
# -o $ORDERER -C channel1 \
# --cafile /opt/home/managedblockchain-tls-chain.pem --tls

# docker exec -e "CORE_PEER_TLS_ENABLED=true" \
# -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
# -e "CORE_PEER_ADDRESS=$PEER"  -e "CORE_PEER_LOCALMSPID=$MSP" \
# -e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
# cli peer chaincode invoke -C channel1 \
# -n mycc -c  '{"function":"initLedger","Args":[]}' \
# -o $ORDERER --cafile /opt/home/managedblockchain-tls-chain.pem --tls

# docker exec -e "CORE_PEER_TLS_ENABLED=true" \
# -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
# -e "CORE_PEER_ADDRESS=$PEER" \
# -e "CORE_PEER_LOCALMSPID=$MSP" \
# -e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
# cli peer chaincode query -C channel1 \
# -n mycc 

# docker exec -e "CORE_PEER_TLS_ENABLED=true" \
# -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
# -e "CORE_PEER_ADDRESS=$PEER"  -e "CORE_PEER_LOCALMSPID=$MSP" \
# -e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH" \
# cli peer chaincode invoke -C channel1 \
# -n mycc -c  '{"function":"createCar","Args":["CAR10", "Toyota", "Prius", "Black", "Alice"]}' \
# -o $ORDERER --cafile /opt/home/managedblockchain-tls-chain.pem --tls



