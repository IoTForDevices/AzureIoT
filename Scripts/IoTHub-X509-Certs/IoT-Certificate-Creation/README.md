# IoT Certificate Creation
In this folder you will find a number of scripts to create different X.509 certificates.
All these certificates are self-signed, including the root certificate, which should be kept as a secret.

Types of certificates that will be used:
- Root Certificate (root of trust)
- Intermediate Certificate (stored in IoT Hub and used to generate IoT Device Certificates)
- Verification Certificate (used to verify the IoT certificate), created with Intermediate Certificate.
- Device Certificates, created with Intermediate Certificate