#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

#######################################################################################
# This script creates a X.509 root certificate and X.509 intermediate certificate
# and installs the intermediate certificate in an IoT Hub. After that, the authenticity
# of the certificate is validated.
#
# Prerequisites: IoT Hub has been created already.
#######################################################################################

show_help() {
    echo "Command"
    echo "  add-iothub-certificate: Create a new X.509 certificate chain to authenticate devices connecting to an IoT Hub."
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
verification_code=""

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
            root_folder="$2"; shift 2 ;;
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

# Read password and store it into secrets.txt file for use by other scrips (could randomize the filename and pass it as additional argument)
IFS= read -s -p Password: pwd
pwd_file=`/bin/mktemp`
echo ${pwd} >> $pwd_file

# Create a new root certificate
echo ""
echo ""
echo "*****************************************************"
echo "Creating a new file system and X.509 Root Certificate"
echo "*****************************************************"
./IoT-Certificate-Creation/create-filesystem.sh ${root_folder}
./IoT-Certificate-Creation/create-root-cert.sh -r ${root_folder} -c ${certificate_name} -p ${pwd_file}

# Create a new intermediate certificate based on the root certificate
echo ""
echo ""
echo "*********************************************"
echo "Creating a new X.509 Intermediate Certificate"
echo "*********************************************"
./IoT-Certificate-Creation/create-intermediate-cert.sh -r ${root_folder} -c ${certificate_name} -p ${pwd_file}

# Upload the intermediate certificate to an IoT Hub and retrieve a verification code from 
# IoT Hub to proof ownership of the uploaded certificate
echo ""
echo ""
echo "***********************************************************"
echo "uploading the intermediate X.509 certificate to the IoT Hub"
echo "***********************************************************"
verification_code_file=`/bin/mktemp`
./IoT-Certificate-Installation/upload-intermediate-cert.sh -i $iot_hub -r $root_folder -c $certificate_name -v $verification_code_file

verification_code=`cat "$verification_code_file"`
rm -f $verification_code_file

# Create a verification certificate signed by the intermediate certificate
echo ""
echo ""
echo "*********************************************"
echo "Creating a new X.509 Verification Certificate"
echo "*********************************************"
./IoT-Certificate-Creation/create-verification-cert.sh -r $root_folder -c $certificate_name -v $verification_code -p $pwd_file
rm -f $pwd_file

# Upload the verification certificate to the IoT Hub
# Create a verification certificate signed by the intermediate certificate
echo ""
echo ""
echo "*****************************************"
echo "Upload the X.509 Verification Certificate"
echo "*****************************************"
./IoT-Certificate-Installation/upload-verification-cert.sh -i $iot_hub -r $root_folder -c $certificate_name

exit 0
