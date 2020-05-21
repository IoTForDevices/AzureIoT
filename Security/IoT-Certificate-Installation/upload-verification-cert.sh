#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

#################################################################################
# This script uses the ac-cli to upload a verification certificate to an IoT Hub
#################################################################################

show_help() {
    echo "Command"
    echo "  upload-verification-cert: Upload a X.509 Verification Certificate to the specified IoT Hub."
    echo "      This certificate is used to proof the X.509 Intermediate Certificate authenticy."
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

OPTS=`getopt -n 'parse-options' -o hi:r:c: --long help,iot-hub:,root-folder:,cert-name: -- "$@"`

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
            root_folder="${2}/ca/intermediate/certs"; shift 2 ;;
        -c | --cert-name )
            certificate_name="$2"; shift 2 ;;
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

# Retrieve the etag value of the uploaded intermediate certificate
etag_value=$(az iot hub certificate show \
    --hub-name ${iot_hub} \
    --name "${certificate_name}-cert" \
    --query etag)

# upload the verification in the IoT Hub
az iot hub certificate verify \
    --hub-name $iot_hub \
    --name "${certificate_name}-cert" \
    --path "${root_folder}/${certificate_name}-verify.cert.pem" \
    --etag "$etag_value"
