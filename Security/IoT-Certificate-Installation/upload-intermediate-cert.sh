#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

#################################################################################
# This script uses the ac-cli to upload an intermediate certificate to an IoT Hub
#################################################################################

if [ $# -ne 3 ]; then
    echo "Usage: upload-intermediate-cert.sh <iot-hub> <root-folder> <certificate-name>"
    exit 1
fi
# if [ $# -ne 4 ]; then
#     echo "Usage: upload-intermediate-cert.sh <iot-hub> <root-folder> <certificate-name> <result-file-name>"
#     exit 1
# fi

iot_hub_name=${1}
root_folder="${2}/ca/intermediate/certs"
cert_name=${3}

# install the certificate in the IoT Hub
etag_value=$(az iot hub certificate create \
    --hub-name ${iot_hub_name} \
    --name "${cert_name}-cert" \
    --path "${root_folder}/${cert_name}-intermediate.cert.pem" \
    --query etag)

# Get a verification code to create a verification certificate
verification_code=$(az iot hub certificate generate-verification-code \
    --hub-name ${iot_hub_name} \
    --name "${cert_name}-cert" \
    --etag ${etag_value} \
    --query properties.verificationCode)

echo ${verification_code}
# echo ${verification_code} > ${4}
