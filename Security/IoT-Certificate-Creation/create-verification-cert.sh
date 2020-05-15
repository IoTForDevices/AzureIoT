#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

###############################################################################
# This script builds a X.509 verification certificate.
# It will used to validate the certificate ownership by signing a verification
# code with the private key that is associated with your X.509 CA certificate.
#
# Pre-requisites: You must have created and uploaded a root or intermediate
# certificate to your IoT Hub and you must have generated a verification code.
###############################################################################


# NOTE: Individual commands are now working, but need to deal properly with passwords.
#       Use intermediate certificate uploaded to IoT Hub
#       Use entire intermediate certificate chain for proof of posession with verification cert.
#       For demo purposes would be great to call the whole chain of scripts from one master script
#       Also need a second intermediate certificate based on the first intermediate cert

if [ $# -ne 3 ]; then
    echo "Usage: create-verification-cert <root-folder> <cert-name> <verification-code>"
    exit 1
fi

# IFS= read -s -p Password: pwd
pwd="MniMSuAadR01!"

root_folder="${1}/ca"
verification_cert_name="${2}-verify"
chain_cert_name="${2}-chain"
verification_code=${2}
cn_name="/CN=${3}"

cd ${root_folder}

# Create an verification key and make sure to keep it secure.
openssl genrsa \
    -aes256 \
    -passout pass:${pwd} \
    -out intermediate/private/${verification_cert_name}.key.pem 4096
chmod 400 intermediate/private/${verification_cert_name}.key.pem

# Use the previously created key to create a certificate signing request (CSR).
openssl req \
    -config intermediate/openssl.cnf \
    -key intermediate/private/${verification_cert_name}.key.pem \
    -subj ${cn_name} \
    -new -sha256 \
    -passin pass:${pwd} \
    -out intermediate/csr/${verification_cert_name}.csr.pem
chmod 444 intermediate/csr/${verification_cert_name}.csr.pem

# echo "Use the Root CA to sign the generated verification CSR"
# Use the root CA to sign the generated verification CSR.
openssl ca -batch \
    -config intermediate/openssl.cnf \
    -passin pass:${pwd} \
    -extensions "server_cert" \
    -days 30 -notext -md sha256 \
    -in intermediate/csr/${verification_cert_name}.csr.pem \
    -out intermediate/certs/${verification_cert_name}.cert.pem
chmod 444 intermediate/certs/${verification_cert_name}.cert.pem

# Verify the intermediate certificate
openssl x509 \
    -noout -text \
    -in intermediate/certs/${verification_cert_name}.cert.pem

echo ""
echo ""

openssl verify \
    -CAfile intermediate/certs/${chain_cert_name}.cert.pem \
    intermediate/certs/${verification_cert_name}.cert.pem

echo ""
echo "CA Verification Certificate Generated At:"
echo "-----------------------------------------"
echo "intermediate/certs/${verification_cert_name}.cert.pem"
echo ""
