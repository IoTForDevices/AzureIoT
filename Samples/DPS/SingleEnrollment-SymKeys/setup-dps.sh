#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

###################################################################################
# This script creates a DPS service and links it to an existing IoT Hub.
#
# Prerequisites: IoT Hub must exist and already contain a valid X.509 certificate
#                that can act as root for the device certificate.
###################################################################################

show_help() {
    echo "Command"
    echo "  setup-dps.sh: Create a new Device Provisioning Service and links it to an existing IoT Hub."
    echo "      More information can be found in the IoT Hub documentation, see" 
    echo "      https://docs.microsoft.com/en-us/azure/iot-dps/about-iot-dps."
    echo ""
    echo "Arguments"
    echo "  --iot-hub -i        [Required] : Name of the IoT Hub that will be linked to the new DPS."
    echo "  --dps-name -d       [Required] : Name of the Device Provisioning Service to be created."
    echo "  --help -h                      : Shows this help message and exit."
}

iot_hub=""
dps_name=""
resource_group=""
location="westeurope"

OPTS=`getopt -n 'parse-options' -o hd:i:lr: --long help,iot-hub:,dps-name:,resource-group -- "$@"`

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
        -d | --dps-name )
            dps_name="$2"; shift 2 ;;
        -l | --location )
            location="$2"; shift 2 ;;
        -r | --resource-group )
            resource_group="$2"; shift 2 ;;
        \? )
            echo "Invalid Option"
            exit 0
            ;;
        --) shift; break;;
        *) break;;
    esac
done

if [[ -z "$iot_hub" || -z "$dps_name" || -z "$resource_group"]]; then
    show_help
    exit 1
fi

# Create a new Device Provisioning Service
echo ""
echo ""
echo "***********************************************************************"
echo "Creating a new Device Provision Service in the specified resource group"
echo "***********************************************************************"
./IoT-Certificate-Installation/create-device-identity.sh -i $iot_hub -d $device_id

# Link the new DPS to the specified IoT Hub
echo ""
echo ""
echo "***************************************"
echo "Creating a new X.509 Device Certificate"
echo "***************************************"
./IoT-Certificate-Creation/create-device-cert.sh -r ${root_folder} -c ${certificate_name} -d $device_id

exit 0
