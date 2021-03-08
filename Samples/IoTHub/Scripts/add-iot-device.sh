#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

###################################################################################
# This script adds a device identity to an IoT Hub and generates
# a X.509 device certificate that will be verified with the X.509 CA chain
# for the particular IoT Hub.
#
# Prerequisites: IoT Hub must exist and already contain a valid X.509 certificate
#                that can act as root for the device certificate.
###################################################################################

show_help() {
    echo "Command"
    echo "  add-iot-device: Create a new device identity on an IoT Hub and a X.509 device certificate"
    echo "      for the device to easily connect the device to the IoT Hub"
    echo "      More information can be found in the IoT Hub documentation, see" 
    echo "      https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-x509ca-overview#authenticating-devices-signed-with-x509-ca-certificates."
    echo "      NOTE: The IoT Hub must already have a valid X.509 CA Certificate that can act as root for the device certificate."
    echo ""
    echo "Arguments"
    echo "  --iot-hub -i        [Required] : Name of the IoT Hub that will receive the X.509 certificate."
    echo "  --root-folder -r    [Required] : Name of the folder where the certificates will be stored."
    echo "  --cert-name -c      [Required] : Name of the X.509 root certificate to be created." 
    echo "  --device-id -d      [Required} : Name of the device to be connected to the IoT Hub."
    echo "  --help -h                      : Shows this help message and exit."
}

iot_hub=""
root_folder=""
certificate_name=""
device_id=""
common_script_root="../../Scripts/IoTHub-X509-Certs"

OPTS=`getopt -n 'parse-options' -o hi:r:c:d: --long help,iot-hub:,root-folder:,cert-name:,device-id: -- "$@"`

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
            root_folder="$2"; shift 2 ;;
        -c | --cert-name )
            certificate_name="$2"; shift 2 ;;
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

if [[ -z "$iot_hub" || -z "$root_folder" || -z "$certificate_name" || -z "$device_id" ]]; then
    show_help
    exit 1
fi

# Create a new device identity
echo ""
echo ""
echo "********************************************************"
echo "Creating a new device identity for the specified IoT Hub"
echo "********************************************************"
$common_script_root/IoT-Certificate-Installation/create-device-identity.sh -i $iot_hub -d $device_id

# Create a new device certificate for the device identity
echo ""
echo ""
echo "***************************************"
echo "Creating a new X.509 Device Certificate"
echo "***************************************"
$common_script_root/IoT-Certificate-Creation/create-device-cert.sh -r ${root_folder} -c ${certificate_name} -d $device_id

exit 0
