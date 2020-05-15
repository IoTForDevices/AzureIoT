#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

#################################################################################
# This script uses the ac-cli to upload a verification certificate to an IoT Hub
#################################################################################

if [ $# -ne 3 ]; then
    echo "Usage: create-filesystem <iot-hub> <root-folder> <certificate-name>"
    exit 1
fi
# if [ $# -ne 4 ]; then
#     echo "Usage: create-filesystem <iot-hub> <root-folder> <certificate-name> <result-file-name>"
#     exit 1
# fi

iot_hub_name=${1}
root_folder="${2}/ca/intermediate/certs"
cert_name=${3}

# upload the verification in the IoT Hub
az iot hub certificate verify \
    --hub-name ${iot_hub_name} \
    --name "${cert_name}-cert" \
    --path "${root_folder}/${cert_name}-verify.cert.pem" \
    --etag AAAAAA2n3Do=
