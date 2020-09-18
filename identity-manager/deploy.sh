#!/bin/bash
##############################################################
#Initial Setup script for Corda Identity Manager
##############################################################

#Pick PKI configuration file
 
java -jar libs/pkitool.jar -f pki-generation.conf --ignore-missing-crl

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
