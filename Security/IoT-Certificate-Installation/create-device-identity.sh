#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

########################################################################################
# This script uses the ac-cli to create a device identity that uses X.509 authentication
########################################################################################

if [ $# -ne 2 ]; then
    echo "Usage: create-device-identity <iot-hub> <device-id>"
    exit 1
fi

iot_hub_name=${1}
device_id=${2}

# create the device identity in the specified iot hub
az iot hub device-identity create \
    --hub-name ${iot_hub_name} \
    --device-id ${device_id} \
    --auth-method x509_ca
