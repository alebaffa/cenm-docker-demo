#!/bin/bash
##############################################################
#Initial Setup script for Corda Identity Manager
##############################################################

#Pick PKI configuration file
 
if [ "$1" == "--crl" ]; then
	cp ./pki-generation-crl.conf ./pki-generation.conf
	java -jar libs/pkitool.jar --config-file pki-generation.conf
else
	cp ./pki-generation-no-crl.conf ./pki-generation.conf
	java -jar libs/pkitool.jar -f pki-generation.conf --ignore-missing-crl
fi

echo "Generated the PKI."

#Copy files for Identity Manager
FILE=./key-stores/corda-identity-manager-keys.jks
if test -f "$FILE"; then
    echo "$FILE exists."
	cp ./key-stores/corda-identity-manager-keys.jks .
	echo "Copied corda-identity-manager-keys.jks"
else
	exit
fi
