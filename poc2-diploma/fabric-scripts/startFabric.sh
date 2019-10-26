#!/bin/bash

set -ev

ARCH=`uname -m`

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export MSYS_NO_PATHCONV=1

ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose.yml down --volumes --remove-orphan
ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose.yml up -d

export FABRIC_START_TIMEOUT=20
echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

docker cp config-channel.sh cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/config-channel.sh
docker exec -it cli bash
./createpeer1.sh && ./createpeer2.sh && ./createpeer3.sh

# # #Trying

# # # docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.poc2/msp" -e "peer0.org1.poc2:7051" peer0.org2.poc2 peer channel join -b composerchannel.block --tls --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.poc2-cert.pem
# # # docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "peer0.org1.poc2:7051" peer0.org3.poc2 peer channel join -b composerchannel.block --tls --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.poc2-cert.pem

# # # docker exec peer0.org2.poc2 peer channel fetch 0 composerchannel.block -c composerchannel -o orderer0.poc2:7050

# # # Join all peer0 to the channel.
# docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.poc2/msp" peer0.org1.poc2 peer channel join -b composerchannel.block --tls --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.poc2-cert.pem

# # # # Create the channel
# docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.poc2/msp" peer1.org1.poc2 peer channel fetch config -o orderer0.poc2:7050 -c composerchannel --tls --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.poc2-cert.pem

# # # # Join all peer1 to the channel.
# docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.poc2/msp" peer1.org1.poc2 peer channel join -b composerchannel_config.block --tls --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.poc2-cert.pem



# #  docker exec peer0.org1.poc2 peer channel fetch 0 composerchannel.block --channelID composerchannel --orderer orderer0.poc2:7050

# # peer channel create -o orderer0.poc2:7050 -c $CHANNEL_NAME -f /etc/hyperledger/composer-channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/poc2/orderers/orderer0.poc2/msp/tlscacerts/tlsca.poc2-cert.pem


# peer channel create -o orderer0.poc2:7050 -c $CHANNEL_NAME -f ./channel-artifacts/composer-channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/poc2/orderers/orderer0.poc2/msp/tlscacerts/tlsca.poc2-cert.pem

# CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.poc2/users/Admin@org2.poc2/msp CORE_PEER_ADDRESS=peer0.org2.poc2:7051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.poc2/peers/peer0.org2.poc2/tls/ca.crt peer channel join -b composerchannel.block