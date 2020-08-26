# Azure IoT Hub Device Provisioning Service (DPS) - Single Device Enrollment with Symmetric Key
This sample covers the following topics:
- Setup DPS
- Link DPS to multiple IoT Hubs
- Provision a single device, identified by a Symmetric Key pair
- Reprovision the device
- Retire the device

### Pre-requisites
You need an existing IoT Hub. 

The device is a simulated device, written in C#. When booted, the device connects to DPS through a fixed endpoint, provides its identity and gets registered with an IoT Hub with a *desired device twin state*. After being registered, the device gets connection information from DPS after which it can connect to the IoT Hub to start sending telemetry data. More information about this process can be [found here](https://docs.microsoft.com/en-us/azure/iot-dps/about-iot-dps#behind-the-scenes).

