# Universidade Federal de Minas Gerais (UFMG) - Projeto Orientado em Computação II

Este projeto é requisito para a graduação no curso de Ciência da Computação da Universidade Federal de Minas Gerais (UFMG). Foi desenvolvido pela aluna Ana Luisa Lima Rodrigues no segundo semestre de 2019.

## Objetivo

O objetivo principal desse Projeto Orientado à Computação é implementar uma Blockchain do Hyperledger Fabric para armazenar diplomas da Universidade Federal de Minas Gerais (UFMG), Universidade Federal do Rio de Janeiro (UFRJ) e Universidade de São Paulo (USP). A principal motivação para o desenvolvimento desse trabalho é a importância que os diplomas possuem atualmente no cenário universitário e profissional.

### Arquitetura

Hyperledger Fabric Composer - Versão 1.2

Implementado com Kafka + Zookeeper

* 3 Organizations
* 1 Channels 
* 3 Org 
* 3 CA 
* 6 Peers 
* 2 Orderers
* 2 CouchDB
* 4 Kafkas
* 3 Zookeepers


### Pré-requisitos

* Docker version 17.06.2-ce or greater
* Go version 1.10.x is required
* Node.js version 8.9.x or greater
* composer version 0.19 or greater
* composer-rest-server version 0.19 or greater

OBS: Esse projeto foi executado no SO Ubuntu em um notebook com processador i7 e 8GB RAM. Veja mais pré-requisitos de acordo com o SO em: <a href="https://hyperledger-fabric.readthedocs.io/en/release-1.2/prereqs.html">`https://hyperledger-fabric.readthedocs.io/en/release-1.2/prereqs.html`</a>


### Instalação

Executar em ordem os seguintes comandos:
```
$ cd fabric-scripts
```
```
$ ./startFabric.sh
```
```
$ ./config-channel.sh
```
```
$ exit
```
```
$ ./config-networks.sh
```

E executar em 3 abas de terminais diferentes:
```
$ blabla1
```
```
$ blabla2
```
```
$ blabla3
```

A API REST do Hyperledger Fabric estará então disponível localmente nas portas 3000, 3001 e 3002, para UFMG, UFRJ e USP, respectivamente. Elas podem ser acessada via browser pela URL: localhost:port

### Autora

Ana Luisa Lima Rodrigues - analuisalrod@gmail.com
