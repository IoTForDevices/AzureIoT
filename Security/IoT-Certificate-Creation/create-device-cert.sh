#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

###########################################################################################
# This script builds a X.509 device certificate.
# It will used to validate the certificate ownership by signing a verification
# code with the private key that is associated with your intermediate X.509 CA certificate.
#
# Pre-requisites: You must have created and uploaded an intermediate
# certificate to your IoT Hub and you must have generated a verification code.
###########################################################################################


# NOTE: Individual commands are now working, but need to deal properly with passwords.
#       Use intermediate certificate uploaded to IoT Hub
#       Use entire intermediate certificate chain for proof of posession with verification cert.
#       For demo purposes would be great to call the whole chain of scripts from one master script
#       Also need a second intermediate certificate based on the first intermediate cert

if [ $# -ne 3 ]; then
    echo "Usage: create-verification-cert <root-folder> <intermediate-ca-name> <device-name>"
    exit 1
fi

# IFS= read -s -p Password: pwd
pwd="MniMSuAadR01!"

root_folder="${1}/ca"
device_cert_name="${3}-device"
chain_cert_name="${2}-chain"
cn_name="/CN=${3}"

cd ${root_folder}

# Create an verification key and make sure to keep it secure.
echo ""
echo "Generated a device creation key."
echo ""
openssl genrsa \
    -aes256 \
    -passout pass:${pwd} \
    -out intermediate/private/${device_cert_name}.key.pem 4096
chmod 400 intermediate/private/${device_cert_name}.key.pem

# Use the above generated key to create a certificate signing request (CSR).
echo ""
echo "Use the generated key to create a certificate signing request (CSR)"
echo ""
openssl req \
    -config intermediate/openssl.cnf \
    -key intermediate/private/${device_cert_name}.key.pem \
    -subj ${cn_name} \
    -new -sha256 \
    -passin pass:${pwd} \
    -out intermediate/csr/${device_cert_name}.csr.pem
chmod 444 intermediate/csr/${device_cert_name}.csr.pem

# Use the Intermediate CA to sign the generated verification CSR.
echo ""
echo "Use the Intermediate CA to sign the generated verification CSR"
echo ""
openssl ca -batch \
    -config intermediate/openssl.cnf \
    -passin pass:${pwd} \
    -extensions "server_cert" \
    -days 1500 -notext -md sha256 \
    -in intermediate/csr/${device_cert_name}.csr.pem \
    -out intermediate/certs/${device_cert_name}.cert.pem
chmod 444 intermediate/certs/${device_cert_name}.cert.pem

# Verify the intermediate certificate
echo ""
echo "Use the Intermediate CA to sign the generated verification CSR"
echo ""
openssl x509 \
    -noout -text \
    -in intermediate/certs/${device_cert_name}.cert.pem

echo ""
echo ""

openssl verify \
    -CAfile intermediate/certs/${chain_cert_name}.cert.pem \
    intermediate/certs/${device_cert_name}.cert.pem

echo ""
echo "CA Verification Certificate Generated At:"
echo "-----------------------------------------"
echo "intermediate/certs/${device_cert_name}.cert.pem"
echo ""


openssl pkcs12 -in intermediate/certs/${device_cert_name}.cert.pem \
        -inkey intermediate/private/${device_cert_name}.key.pem \
        -passin pass:${pwd} \
        -password pass:${pwd} \
        -export -out intermediate/certs/${device_cert_name}.cert.pfx

echo "${cert_type_diagnostic} PFX Certificate Generated At:"
echo "--------------------------------------------"
echo "    ${certificate_dir}/certs/${device_prefix}.cert.pfx"
