#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

#################################################################################
# This script uses the ac-cli to upload an intermediate certificate to an IoT Hub
#################################################################################

show_help() {
    echo "Command"
    echo "  upload-intermediate-cert: Upload a new X.509 Intermediate Certificate to the specified IoT Hub."
    echo "      Also generate a verification code that can be used to proof the certificate authenticy."
    echo "      More information can be found in the IoT Hub documentation, see https://docs.microsoft.com/azure/iot-hub/iot-hub-x509ca-overview/"
    echo ""
    echo "Arguments"
    echo "  --iot-hub -i        [Required] : Name of the IoT Hub that will receive the X.509 certificate."
    echo "  --root-folder -r    [Required] : Name of the folder where the certificates will be stored."
    echo "  --cert-name -c      [Required] : Name of the X.509 root certificate to be created." 
    echo "  --help -h                      : Shows this help message and exit."
}

iot_hub=""
root_folder=""
certificate_name=""
verification_code_file=""

OPTS=`getopt -n 'parse-options' -o hi:r:c:v: --long help,iot-hub:,root-folder:,cert-name:,verify-filename: -- "$@"`

eval set -- "$OPTS"

#extract options and their arguments into variables
while true ; do
    case "$1" in
        -h | --help )
            show_help
            exit 0
            ;;
        -i | --iot-hub )
            iot_hub="$2"; shift 2 ;;
        -r | --root-folder )
            root_folder="$2/ca/intermediate/certs"; shift 2 ;;
        -c | --cert-name )
            certificate_name="$2"; shift 2 ;;
        -v | --verify-filename )
            verification_code_file="$2"; shift 2 ;;
        \? )
            echo "Invalid Option"
            exit 0
            ;;
        --) shift; break;;
        *) break;;
    esac
done

if [[ -z "$iot_hub" || -z "$root_folder" || -z "$certificate_name" ]]; then
    show_help
    exit 1
fi

# install the certificate in the IoT Hub
etag_value=$(az iot hub certificate create \
    --hub-name ${iot_hub} \
    --name "${certificate_name}-cert" \
    --path "${root_folder}/${certificate_name}-intermediate.cert.pem" \
    --query etag)

# Get a verification code to create a verification certificate
verification_code=$(az iot hub certificate generate-verification-code \
    --hub-name ${iot_hub} \
    --name "${certificate_name}-cert" \
    --etag ${etag_value} \
    --query properties.verificationCode)

if [[ -z "$verification_code_file" ]]; then
    echo ${verification_code}
else
    echo $verification_code | sed "s/\"//g" >> ${verification_code_file}
fi
