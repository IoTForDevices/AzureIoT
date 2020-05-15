#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

###################################################################################
# This script reads a verification code from an installed IoT Hub X.509 certificate
# and uses the verification code to validate the certificate by uploading a
# signed verification certificate. 
###################################################################################

if [ $# -ne 3 ]; then
    echo "Usage: create-filesystem <iot-hub> <root-folder> <certificate-name>"
    exit 1
fi

echo "Installing"
verification_code_file=`/bin/mktemp`
./IoT-Certificate-Installation/install-root-cert.sh $1 $2 $3 $verification_code_file

verification_code=`cat $verification_code_file`
rm -f $verification_code_file

./IoT-Certificate-Creation/create-verification-cert.sh $2 $3 $verification_code 
