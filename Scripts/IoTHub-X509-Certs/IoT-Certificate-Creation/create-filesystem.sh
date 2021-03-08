#!/bin/bash

## Copyright (c) IoTForDevices. All rights reserved.
## Licensed under the MIT license. See LICENSE file in the project root for full license information.

###############################################################################
# This script builds a directory structure to be used to setup an
# X.509 certificate chain for CA deployment.
#
# These certs are mainly used for testing and development.
###############################################################################

if [ $# -ne 1 ]; then
    echo "Usage: create-filesystem <root-folder>"
    exit 1
else
    echo $1
fi

script_folder=`dirname "$0"`
root_folder="${1}"
ca_root_folder="${root_folder}/ca"
intermediate_folder="${ca_root_folder}/intermediate"

rm -r -f ${root_folder}

# Create the root CA file structure
mkdir ${root_folder}
mkdir ${ca_root_folder}

mkdir ${ca_root_folder}/crl
mkdir ${ca_root_folder}/private
chmod 700 ${ca_root_folder}/private
mkdir ${ca_root_folder}/certs
mkdir ${ca_root_folder}/newcerts

cp ${script_folder}/openssl.cnf ${ca_root_folder}

touch ${ca_root_folder}/index.txt
touch ${ca_root_folder}/index.txt.attr
echo 1000 > ${ca_root_folder}/serial

# Create the intermediate CA file structure
mkdir ${intermediate_folder}

mkdir ${intermediate_folder}/crl
mkdir ${intermediate_folder}/csr
mkdir ${intermediate_folder}/private
chmod 700 ${intermediate_folder}/private
mkdir ${intermediate_folder}/certs
mkdir ${intermediate_folder}/newcerts

cp ${script_folder}/openssl_intermediate.cnf ${intermediate_folder}/openssl.cnf

touch ${intermediate_folder}/index.txt
touch ${intermediate_folder}/index.txt.attr
echo 1000 > ${intermediate_folder}/serial
echo 1000 > ${intermediate_folder}/crlnumber
