#!/bin/bash
composer network install -a diploma@0.0.1.bna -c PeerAdminUFMG@hlfv1
composer network install -a diploma@0.0.1.bna -c PeerAdminUFRJ@hlfv1
composer network install -a diploma@0.0.1.bna -c PeerAdminUSP@hlfv1

composer identity request -c PeerAdminUFMG@hlfv1 -u admin -s adminpw -d ufmg
composer identity request -c PeerAdminUFRJ@hlfv1 -u admin -s adminpw -d ufrj
composer identity request -c PeerAdminUSP@hlfv1 -u admin -s adminpw -d usp

composer network start --networkName diploma --networkVersion 0.0.1 --networkAdmin ufmg --networkAdminCertificateFile ufmg/admin-pub.pem --networkAdmin ufrj --networkAdminCertificateFile ufrj/admin-pub.pem --networkAdmin usp --networkAdminCertificateFile usp/admin-pub.pem --card PeerAdminUFMG@hlfv1 

composer card create -p connection-ufmg.json -u ufmg -n diploma -c ufmg/admin-pub.pem -k ufmg/admin-priv.pem
composer card import -f ufmg@diploma.card
composer network ping -c ufmg@diploma
composer identity list -c ufmg@diploma

composer card create -p connection-ufrj.json -u ufrj -n diploma -c ufrj/admin-pub.pem -k ufrj/admin-priv.pem
composer card import -f ufrj@diploma.card
composer network ping -c ufrj@diploma
composer identity list -c ufrj@diploma

composer card create -p connection-usp.json -u usp -n diploma -c usp/admin-pub.pem -k usp/admin-priv.pem
composer card import -f usp@diploma.card
composer network ping -c usp@diploma
composer identity list -c usp@diploma

composer network ping -c ufmg@diploma
composer network ping -c ufrj@diploma
composer network ping -c usp@diploma

# composer-rest-server -c ufmg@diploma -n never
# composer-rest-server -c ufrj@diploma -n never -p 3001
# composer-rest-server -c usp@diploma -n never -p 3002

# composer network upgrade -n <business-network-name> -V <business-network-version> -c <business-network-card>