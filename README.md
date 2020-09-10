# CENM on Docker demo

- [CENM on Docker demo](#cenm-on-docker-demo)
  - [Description](#description)
  - [Pre-requisite](#pre-requisite)
  - [How to deploy](#how-to-deploy)
    - [Set up Identity Manager](#set-up-identity-manager)
    - [Register Notary to Identity Manager](#register-notary-to-identity-manager)
    - [Set up Network Map service](#set-up-network-map-service)
    - [Register the Corda Node to Identity Manager](#register-the-corda-node-to-identity-manager)
    - [Start the Notary and Node](#start-the-notary-and-node)
  - [Connect to Node RPC from terminal](#connect-to-node-rpc-from-terminal)
  - [Clean up](#clean-up)

A setup template for deploying a network with Corda Enterprise Network Manager (CENM) and one Corda Node.

**Note:** The primary goal of this template is to allow developers to quickly set up a Corda network locally using Docker and Docker Compose. If you wish to set up a network in a cloud environment, you will need to modify the configurations according to your environment settings.

##  Description
This template follows the [Enterprise Network Manager Quick Start Guide](https://docs.cenm.r3.com/quick-start.html#register-your-notary-with-the-identity-manager) to set up the following entities:

1. Identity Manager
2. Network Map
3. Notary node
4. PartyA node

As the instructions in the Quick Start Guide requires copying files around manually, the template includes bash scripts to do that for you.

Supported version:

- Corda Enterprise 4.5
- Corda Enterprise Network Manager 1.3.0

## Pre-requisite

As Corda Enterprise Network Manager (CENM) is a tool provided only to customers eligible for using enterprise version of Corda, the JAR files in CENM are not included in this repository. **It is assumed you already have access to CENM.** 

You will need the following files:

- The Identity Manager distribution zip
- The Network Map distribution zip
- The PKI Tool distribution zip (for PKI generation)
- A Corda jar (for the Notary node)

## How to deploy

First of all, you need to clone this template to your local machine:

`git clone https://github.com/sbir3japan/cenm-docker-demo.git`

Under the root are four directories, each corresponding to the entities to be created:

- `identity-manager/`
- `network-map`
- `notary`
- `node01`

### Set up Identity Manager

Copy all files inside the Identity Manager distribution zip to `identity-manager/libs`. 

There should be 3 JAR files:
- `identitymanager.jar`
- `bcpkix-jdk15on-1.64.jar`
- `bcprov-jdk15on-1.64.jar`

Also copy `pkitool.jar` inside the PKI Tool distribution zip to `identity-manager/libs`.

In terminal, run the deploy shell script from the root folder `cenm-docker-demo`) 

```
docker-compose -f docker-compose-deploy.yaml up identity-manager
```
It will do two things for you:

1. Generate the PKI
2. Start the Identity Manager tool

Upon successful execution, you should see an output similar to the following in your terminal:

```
12:32 $ docker-compose -f docker-compose-deploy.yaml up identity-manager

Starting PKI generation...
  - Generating key pair and certificate for cordatlscrlsigner
 	✔ Key pair with alias [cordatlscrlsigner] generated within key store [corda-tls-crl-signer-keys].
...
...
...
identity-manager    | Generated the PKI.
identity-manager    | ./key-stores/corda-identity-manager-keys.jks exists.
identity-manager    | Copied corda-identity-manager-keys.jks
identity-manager    | Binding Shell SSHD server on port 10022
identity-manager    |  Network management web services started on 0.0.0.0:10000 with [RegistrationWebService, MonitoringWebService]
```
Congratulations! The Identity Manager is up and running!

### Register Notary to Identity Manager

Copy `corda.jar` to `notary/libs`, then run the following command in another terminal (make sure you are in the root folder `cenm-docker-demo`) to register the node with Identity Manager (Identity Manager container must be up and running when you do this step) 

```
docker-compose -f docker-compose-deploy.yaml up notary
```

Upon successful executions, you should see an output similar to the following:

```
...
Submitting certificate signing request to Corda certificate signing server.
Successfully submitted request to Corda certificate signing server, request ID: 6D47651B95D2317813F1E5B09E8668BF92D056A3503AEF881EECF874D3DF094A.
Start polling server for certificate signing approval.
...
...
##### [ this can take some time, normally few seconds more...]######
...
notary              | Node trust store stored in /opt/corda/notary/certificates/truststore.jks.
notary              | Successfully registered Corda node with compatibility zone, node identity keys and certificates are stored in '/opt/corda/notary/certificates', it is advised to backup the private keys and certificates.
notary              | Corda node will now terminate.
notary exited with code 0
```
Now the Notary is registered to the Identity Manager, but the Notary container is shut down. This is normal because the Network Map has to be set up before restarting the Notary container.


> **Note:** the Corda JAR file should be named exactly `corda.jar`, as it is the name the deploy script expects. If you need to name it something different, you have to either modify "corda.jar" in `docker-compose-deploy.yaml` to the correct file name, or  the initial registration without the deploy script.


### Set up Network Map service

Copy all files inside the Network Map distribution zip to `network-map/libs`. 

There should be 3 JAR files:
- `networkmap.jar`
- `bcpkix-jdk15on-1.64.jar`
- `bcprov-jdk15on-1.64.jar`

In another terminal, run the deploy shell script under `cenm-docker-demo`:

```
docker-compose -f docker-compose-deploy.yaml up network-map 
```
Docker Compose will copy 2 files generated by the PKI tool in the Identity Manager setup:

`key-stores/corda-network-map-keys.jks`
`trust-stores/network-root-truststore.jks`

then generate the network parameter configuration file `network-parameters.conf`.

Upon successful deploy, you should see an output similar to the following:

```
14:48 $ docker-compose -f docker-compose-deploy.yaml up network-map 
...
...
...
network-map_1       |  Binding Shell SSHD server on port 3330
network-map_1       |  Network management web services started on network-map:20000 with [NetworkMapRESTProtocol, NetworkMapRESTUserProtocol, MonitoringWebService]
```

Congratulations! The Network Map is up and running!

### Register the Corda Node to Identity Manager

In this template, node configuration file `node.conf` is already provided, which comes with the basic settings required for a Corda node. However, you can modify the configurations that suits your need.

Copy `corda.jar` to `node01/libs`, then run the following command to register partyA with Identity Manager:

```
docker-compose -f docker-compose-deploy.yaml up node01
```

Upon successful deploy, you should see an output similar to the following:

```
node01_1            | Successfully registered Corda node with compatibility zone, node identity keys and certificates are stored in '/opt/corda/node01/certificates', it is advised to backup the private keys and certificates.
node01_1            | Corda node will now terminate.
cenm-docker-demo_node01_1 exited with code 0
```
The node01 Docker container is not running anymore. This is normal, you are going to start it in the following step along with the Notary.

### Start the Notary and Node

With both Identity Manager and Network Map Docker containers running, you can now start the Notary and the Node by running:

```
docker-compose -f docker-compose-notary-node.yaml up 
```

> **Note** the different docker-compose file

Congratulations! You now have a private network running locally with Docker Compose.

## Connect to Node RPC from terminal
If you want to connect to the Corda Interactive shell, you need to open a terminal and make a SSH connection to

`ssh -p 61101 testuser@localhost`

You will be requested to prompt the password (provided in `node01/node.conf`).
If it is successful, you will see the following:

```
Welcome to the Corda interactive shell.
You can see the available commands by typing 'help'.

Thu Sep 10 01:39:14 UTC 2020>>>
```


## Clean up
The following script will removes:
- all artifacts from the subfolders
- all docker images and containers

From the terminal run
```
./clean.sh
```