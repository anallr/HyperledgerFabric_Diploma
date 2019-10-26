
#!/bin/bash

# Exit on first error
set -e
# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Grab the file names of the keystore keys
ORG1KEY="$(ls composer/crypto-config/peerOrganizations/org1.poc2/users/Admin@org1.poc2/msp/keystore/)"

ORDERER0CA="$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' composer/crypto-config/ordererOrganizations/poc2/orderers/orderer0.poc2/tls/ca.crt)"
ORDERER1CA="$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' composer/crypto-config/ordererOrganizations/poc2/orderers/orderer1.poc2/tls/ca.crt)"
ORG1CA="$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' composer/crypto-config/peerOrganizations/org1.poc2/peers/peer0.org1.poc2/tls/ca.crt)"
ORG2CA="$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' composer/crypto-config/peerOrganizations/org2.poc2/peers/peer0.org2.poc2/tls/ca.crt)"
ORG3CA="$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' composer/crypto-config/peerOrganizations/org3.poc2/peers/peer0.org3.poc2/tls/ca.crt)"

Parse_Arguments() {
	while [ $# -gt 0 ]; do
		case $1 in
			--help)
				HELPINFO=true
				;;
			--host | -h)
                shift
				HOST="$1"
				;;
            --noimport | -n)
				NOIMPORT=true
				;;
		esac
		shift
	done
}

HOST=localhost
Parse_Arguments $@

if [ "${HELPINFO}" == "true" ]; then
    Usage
fi

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "${HL_COMPOSER_CLI}" ]; then
  HL_COMPOSER_CLI=$(which composer)
fi

echo
# check that the composer command exists at a version >v0.16
COMPOSER_VERSION=$("${HL_COMPOSER_CLI}" --version 2>/dev/null)
COMPOSER_RC=$?

if [ $COMPOSER_RC -eq 0 ]; then
    AWKRET=$(echo $COMPOSER_VERSION | awk -F. '{if ($2<19) print "1"; else print "0";}')
    if [ $AWKRET -eq 1 ]; then
        echo Cannot use $COMPOSER_VERSION version of composer with fabric 1.1, v0.19 or higher is required
        exit 1
    else
        echo Using composer-cli at $COMPOSER_VERSION
    fi
else
    echo 'No version of composer-cli has been detected, you need to install composer-cli at v0.19 or higher'
    exit 1
fi

cat << EOF > connection.json
{
    "name": "hlfv1",
    "x-type": "hlfv1",
    "x-commitTimeout": 300,
    "version": "1.0.0",
    "channels": {
        "composerchannel": {
            "orderers": [
                "orderer0.poc2",
                "orderer1.poc2"
            ],
            "peers": {
                "peer0.org1.poc2": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer1.org1.poc2": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer0.org2.poc2": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer1.org2.poc2": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer0.org3.poc2": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer1.org3.poc2": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                }
            }
        }
    },
    "organizations": {
        "Org1": {
            "mspid": "Org1MSP",
            "peers": [
                "peer0.org1.poc2",
                "peer1.org1.poc2"
            ],
            "certificateAuthorities": [
                "ca.org1.poc2"
            ]
        },
        "Org2": {
            "mspid": "Org2MSP",
            "peers": [
                "peer0.org2.poc2",
                "peer1.org2.poc2"
            ],
            "certificateAuthorities": [
                "ca.org2.poc2"
            ]
        },
        "Org3": {
            "mspid": "Org3MSP",
            "peers": [
                "peer0.org3.poc2",
                "peer1.org3.poc2"
            ],
            "certificateAuthorities": [
                "ca.org3.poc2"
            ]
        }
    },
    "orderers": {
        "orderer0.poc2": {
            "url": "grpcs://localhost:7050",
            "grpcOptions": {
                "ssl-target-name-override": "orderer0.poc2"
            },
            "tlsCACerts": {
                "pem": "${ORDERER0CA}"
            }
        },
        "orderer1.poc2": {
            "url": "grpcs://localhost:8050",
            "grpcOptions": {
                "ssl-target-name-override": "orderer1.poc2"
            },
            "tlsCACerts": {
                "pem": "${ORDERER1CA}"
            }
        }
    },
    "peers": {
        "peer0.org1.poc2": {
            "url": "grpcs://localhost:7051",
            "eventUrl": "grpcs://localhost:7053",
            "grpcOptions": {
                "ssl-target-name-override": "peer0.org1.poc2"
            },
            "tlsCACerts": {
                "pem": "${ORG1CA}"
            }
        },
        "peer1.org1.poc2": {
            "url": "grpcs://localhost:8051",
            "eventUrl": "grpcs://localhost:8053",
            "grpcOptions": {
                "ssl-target-name-override": "peer1.org1.poc2"
            },
            "tlsCACerts": {
                "pem": "${ORG1CA}"
            }
        },
        "peer0.org2.poc2": {
            "url": "grpcs://localhost:9051",
            "eventUrl": "grpcs://localhost:9053",
            "grpcOptions": {
                "ssl-target-name-override": "peer0.org2.poc2"
            },
            "tlsCACerts": {
                "pem": "${ORG2CA}"
            }
        },
        "peer1.org2.poc2": {
            "url": "grpcs://localhost:10051",
            "eventUrl": "grpcs://localhost:10053",
            "grpcOptions": {
                "ssl-target-name-override": "peer1.org2.poc2"
            },
            "tlsCACerts": {
                "pem": "${ORG2CA}"
            }
        },
        "peer0.org3.poc2": {
            "url": "grpcs://localhost:11051",
            "eventUrl": "grpcs://localhost:11053",
            "grpcOptions": {
                "ssl-target-name-override": "peer0.org3.poc2"
            },
            "tlsCACerts": {
                "pem": "${ORG3CA}"
            }
        },
        "peer1.org3.poc2": {
            "url": "grpcs://localhost:12051",
            "eventUrl": "grpcs://localhost:12053",
            "grpcOptions": {
                "ssl-target-name-override": "peer1.org3.poc2"
            },
            "tlsCACerts": {
                "pem": "${ORG3CA}"
            }
        }
    },
    "certificateAuthorities": {
        "ca.org1.poc2": {
            "url": "https://localhost:7054",
            "caName": "ca.org1.poc2",
            "httpOptions": {
                "verify": false
            }
        },
        "ca.org2.poc2": {
            "url": "https://localhost:8054",
            "caName": "ca.org2.poc2",
            "httpOptions": {
                "verify": false
            }
        },
        "ca.org3.poc2": {
            "url": "https://localhost:9054",
            "caName": "ca.org3.poc2",
            "httpOptions": {
                "verify": false
            }
        }
    }
}
EOF

PRIVATE_KEY="${DIR}"/composer/crypto-config/peerOrganizations/org1.poc2/users/Admin@org1.poc2/msp/keystore/"${ORG1KEY}"
CERT="${DIR}"/composer/crypto-config/peerOrganizations/org1.poc2/users/Admin@org1.poc2/msp/signcerts/Admin@org1.poc2-cert.pem

if [ "${NOIMPORT}" != "true" ]; then
    CARDOUTPUT=/tmp/PeerAdmin@hlfv1.card
else
    CARDOUTPUT=PeerAdmin@hlfv1.card
fi

"${HL_COMPOSER_CLI}"  card create -p connection.json -u PeerAdmin -c "${CERT}" -k "${PRIVATE_KEY}" -r PeerAdmin -r ChannelAdmin --file $CARDOUTPUT

if [ "${NOIMPORT}" != "true" ]; then
    if "${HL_COMPOSER_CLI}"  card list -c PeerAdmin@hlfv1 > /dev/null; then
        "${HL_COMPOSER_CLI}"  card delete -c PeerAdmin@hlfv1
    fi

    "${HL_COMPOSER_CLI}"  card import --file /tmp/PeerAdmin@hlfv1.card 
    "${HL_COMPOSER_CLI}"  card list
    echo "Hyperledger Composer PeerAdmin card has been imported, host of fabric specified as '${HOST}'"
    rm /tmp/PeerAdmin@hlfv1.card
else
    echo "Hyperledger Composer PeerAdmin card has been created, host of fabric specified as '${HOST}'"
fi
echo "Hyperledger Composer PeerAdmin card has been imported"
composer card list