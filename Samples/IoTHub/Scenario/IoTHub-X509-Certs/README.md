# Azure IoT Hub with X.509 Certificate Authentication

## Introduction
This repository contains a number of bash scripts that can help you to create / install / validate
X.509 certificates for use with an Azure IoT Hub. There are also scripts that can create device
identities with corresponding device certificates. More information on securing IoT Hubs with X.509
certificates can be found in the [Microsoft documentatation](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-security-x509-get-started)

Pre-requisites: You must login to the right Azure subscription using az-cli prior to invoking the scripts. You also must have an IoT Hub ready to use.

## Workflow
You will find a collection of scripts that will help you create X.509 certificates and install them on an IoT Hub.
These scripts work in a Linux environment and have been tested with Ubuntu 18.04 LTS. The scripts should also work in WSL[2].

The following folder structure is used:
- AzureIoT (Repo Root)
  - Samples
    - IoTHub
      - Code (Sample code, including simulated sample device with X.509 certificate)
      - Scripts (scripts to create / install X.509 certificates)
  - Scripts
    -IoTHub-X509-Certs (helper scripts to create a X.509 certificate chain)

1) Create all necessary certificates by invoking ```add-iothub-certificates.sh``` with proper parameters. You will be prompted for a password to protect the private key you are going to create.

``` bash
Scripts/add-iothub-certificate.sh \
    --iot-hub iot-f-mst01 \
    --root-folder ~/ca-mst01 \
    --cert-name mst01    
```

2) Create device identies and corresponding X.509 device certificates by invoking ```add-iot-device.sh``` with proper parameters. You will be prompted for a password. Make sure to provide the same password that you enteded in step 1 of this description.

``` bash
Scripts/add-iot-device.sh \
    --iot-hub iot-f-mst01 \
    --root-folder ~/ca-mst01 \
    --cert-name mst01 \
    --device-id dev-mst01
```

3) Test if a (simulated device) with the X.509 certificate can connect to the IoT Hub by running a simulated device from inside Visual Studio Code. You will be prompted by the application for the device-id, the IoT Hub name, an absolute path to the device certificate and the X.509 password. Prior to running the device simulator, you must have executed steps 1 and 2 of this description.

``` bash
cd Code/SimultedX509Device
dotnet restore
dotnet run
    Enter device-id: dev-mst01
    Enter IoT Hub name: iot-f-mst01
    Enter path to device certificate (pfx file): /home/maarten/ca-mst01/ca/intermediate/certs/dev-mst01-device.cert.pfx
    Enter X.509 Password:

Successfully created DeviceClient!
Device sending 5 messages to IoTHub...

        08/18/2020 13:00:17> Sending message: 0, Data: [{"deviceId":"dev-mst01","messageId":0,"temperature":24,"humidity":77}]
        08/18/2020 13:00:17> Sending message: 1, Data: [{"deviceId":"dev-mst01","messageId":1,"temperature":30,"humidity":72}]
        08/18/2020 13:00:17> Sending message: 2, Data: [{"deviceId":"dev-mst01","messageId":2,"temperature":33,"humidity":60}]
        08/18/2020 13:00:17> Sending message: 3, Data: [{"deviceId":"dev-mst01","messageId":3,"temperature":24,"humidity":79}]
        08/18/2020 13:00:18> Sending message: 4, Data: [{"deviceId":"dev-mst01","messageId":4,"temperature":21,"humidity":68}]
Exiting...    
```

> NOTE: The code sample can also run on Windows inside a command prompt, but you do need a copy of the generated device certificate, since that can only be generated in Linux for this example.

## Using OpenSSL
The workflow described here is good for test purposes and to secure IoT maker solutions. Here is a [nice simple article on using OpenSSL](https://blog.ipswitch.com/how-to-use-openssl-to-generate-certificates).
In Enterprise Environments, it is strongly advices to make use of X.509 certificates from a root certificate authority (CA).