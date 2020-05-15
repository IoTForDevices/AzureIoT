#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

###############################################################################
# This script builds a new X.509 root certificate.
# It will used as the root of trust for a chain of security certificates. 
#
# These certs are mainly used for testing and development.
#
# Pre-requisites: Run the create-filesystem script first.
###############################################################################

if [ $# -ne 2 ]; then
    echo "Usage: create-root-cert <root-folder> <cert-name>"
    exit 1
fi

# IFS= read -s -p Password: pwd
pwd="MniMSuAadR01!"

root_folder="${1}/ca"
root_cert_name="${2}-root"

cd ${root_folder}



# write the root directory and the certificate name in the cnf file
sed -i "8s\\dir_place_holder\\${root_folder}\\" openssl.cnf
sed -i "17s\\root_key_placeholder\\${root_cert_name}.key.pem\\" openssl.cnf
sed -i "18s\\root_cert_placeholder\\${root_cert_name}.cert.pem\\" openssl.cnf
sed -i "22s\\root_crl_placeholder\\${root_cert_name}.crl.pem\\" openssl.cnf

# Create a root key and make sure to keep it secure.
openssl genrsa \
    -aes256 \
    -passout pass:${pwd} \
    -out private/${root_cert_name}.key.pem \
    4096
chmod 400 private/${root_cert_name}.key.pem

# Use the previously created root key to create a root certificate.
openssl req -batch \
    -config openssl.cnf \
    -new -x509 -days 7300 -sha256 -extensions v3_ca \
    -passin pass:${pwd} \
    -key private/${root_cert_name}.key.pem \
    -out certs/${root_cert_name}.cert.pem
chmod 444 certs/${root_cert_name}.cert.pem

# Verify the root certificate
openssl x509 -noout -text -in certs/${root_cert_name}.cert.pem

echo ""
echo "CA Root Certificate Generated At:"
echo "---------------------------------"
echo "${root_folder}/certs/${root_cert_name}.cert.pem"
echo ""

