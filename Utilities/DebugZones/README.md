# Debug Zones
## Introduction
Originally found in Windows CE, Debug Zones are an extremely useful collection of macro's that will help debugging your embedded system.
Once the device is debugged, the macro's can be disabled, decreasing footprint for the retail version of your embedded device.
Debug Zones allow you to divide your debug messages into 16 zones and each of these zones can be turned on or off at run-time. This allows you to control the verbosity of your debug output and helps prevent cluttering of messages.
You can find more information about the origin of [Debug Zones in this excellent document](https://docs.microsoft.com/en-us/archive/blogs/ce_base/debug-messages-and-debug-zones-in-windows-ce).
## Usage
The sample implementation you find here contains some code that is specific to the OS you are running on. Other parts are as portable as possible, however, you still need to define your own Debug Zones to something that makes sense for you.