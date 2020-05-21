#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

########################################################################################
# This script uses the ac-cli to create a device identity that uses X.509 authentication
########################################################################################

show_help() {
    echo "Command"
    echo "  create-device-identity: Create a new device identity for the specified IoT Hub."
    echo ""
    echo "Arguments"
    echo "  --iot-hub -i    [Required] : Name of the IoT Hub for the device to connect to."
    echo "  --device-id -d  [Required] : Name of the device identity for the new device."
    echo "  --help -h                  : Shows this help message and exit."
}

iot_hub_name=""
device_id=""

OPTS=`getopt -n 'parse-options' -o hi:d: --long help,iot-hub:,device-id: -- "$@"`

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
        -d | --device-id )
            device_id="$2"; shift 2 ;;
        \? )
            echo "Invalid Option"
            exit 0
            ;;
        --) shift; break;;
        *) break;;
    esac
done

if [[ -z "$iot_hub" || -z "$device_id" ]]; then
    show_help
    exit 1
fi

# create the device identity in the specified iot hub
az iot hub device-identity create \
    --hub-name $iot_hub \
    --device-id $device_id \
    --auth-method x509_ca
