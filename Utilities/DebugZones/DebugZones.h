/**************************************************************************************************
 * Module Name: DebugZones.h
 * Version:     2.0.9
 * Description: Definition of a number of macro's that help debugging the solution.
 *              These macro's allow more or less debug information to be displayed, allowing to 
 *              zoom in into problem area's. Debugging information is displayed in the VS Code
 *              terminal window (or any other remote terminal application), being send from the
 *              target over USB (RS323 over USB). The global variable dpCurSettings determines
 *              which data is to be displayed. This value can be set in code, but can also be
 *              set dynamically through the digital twin.
 *              NOTE: When enabled (meaning the environment varialbe LOGGING is defined), the
 *                    application grows significantly because all debug info is not part of the
 *                    binary. When LOGGING is not defined, debug info is not part of the binary
 *                    and the digital twin value is being ignored. When building the 
 *                    application for OTA, make sure that LOGGING is not enabled.
 * Copyright (c) IoTForDevices. All rights reserved.
 * Licensed under the MIT license. 
 ***********************************************************************************************/

#ifndef DEBUGZONES_H_
#define DEBUGZONES_H_

#define LOGGING

#ifdef LOGGING

typedef struct _DBGPARAM {
    char	      lpszName[32];           // Name of module
    char          rglpszZones[16][32];    // Names of zones for first 16 bits
    unsigned long ulZoneMask;             // Current zone Mask
} DBGPARAM, *LPDBGPARAM;

extern DBGPARAM dpCurSettings;

#define ZONEMASK(n) (0x00000001<<(n))
#define DEBUGZONE(n)  (dpCurSettings.ulZoneMask & (0x00000001<<(n)))

// Definitions for our debug zones
#define ZONE0_TEXT            ""
#define ZONE1_TEXT            ""
#define ZONE2_TEXT            ""
#define ZONE3_TEXT            ""
#define ZONE4_TEXT            ""
#define ZONE5_TEXT            ""
#define ZONE6_TEXT            ""
#define ZONE7_TEXT            ""
#define ZONE8_TEXT            ""
#define ZONE9_TEXT            ""
#define ZONE10_TEXT           ""
#define ZONE11_TEXT           ""
#define ZONE12_TEXT           "Verbose"
#define ZONE13_TEXT           "Info"
#define ZONE14_TEXT           "Warning"
#define ZONE15_TEXT           "Error"

// These macros can be used as condition flags for LOGMSG
#define ZONE_00               DEBUGZONE(0)
#define ZONE_01               DEBUGZONE(1)
#define ZONE_02               DEBUGZONE(2)
#define ZONE_03               DEBUGZONE(3)
#define ZONE_04               DEBUGZONE(4)
#define ZONE_05               DEBUGZONE(5)
#define ZONE_06               DEBUGZONE(6)
#define ZONE_07               DEBUGZONE(7)
#define ZONE_08               DEBUGZONE(8)
#define ZONE_09               DEBUGZONE(9)
#define ZONE_10               DEBUGZONE(10)
#define ZONE_11               DEBUGZONE(11)
#define ZONE_VERBOSE          DEBUGZONE(12)
#define ZONE_INFO             DEBUGZONE(13)
#define ZONE_WARNING          DEBUGZONE(14)
#define ZONE_ERROR            DEBUGZONE(15)

// These macros can be used to indicate which zones to enable by default (see RETAILZONES and DEBUGZONES below)
#define ZONEMASK_00         ZONEMASK(0)
#define ZONEMASK_01     ZONEMASK(1)
#define ZONEMASK_02       ZONEMASK(2)
#define ZONEMASK_03  ZONEMASK(3)
#define ZONEMASK_04       ZONEMASK(4)
#define ZONEMASK_05      ZONEMASK(5)
#define ZONEMASK_06    ZONEMASK(6)
#define ZONEMASK_07     ZONEMASK(7)
#define ZONEMASK_08   ZONEMASK(8)
#define ZONEMASK_09           ZONEMASK(9)
#define ZONEMASK_10           ZONEMASK(10)
#define ZONEMASK_11           ZONEMASK(11)
#define ZONEMASK_VERBOSE      ZONEMASK(12)
#define ZONEMASK_INFO         ZONEMASK(13)
#define ZONEMASK_WARNING      ZONEMASK(14)
#define ZONEMASK_ERROR        ZONEMASK(15)

#define DEBUGZONES      ZONEMASK_FUNCTION | ZONEMASK_MAINLOOP | ZONEMASK_ERROR | ZONEMASK_WARNING
//#define DEBUGZONES      0xFFFF

#define DEBUGMSG(cond, ...) do { if (cond) { (void)printf(" [%-25s] %04d - %s: ", __FILE__, __LINE__, FUNC_NAME); (void)printf(__VA_ARGS__); printf("\r\n"); } } while ((void)0, 0)
#define DEBUGMSG_RAW(cond, ...) do { if (cond) { (void)printf(__VA_ARGS__); } } while ((void)0, 0)
#define DEBUGMSG_FUNC_IN(...) do { if (ZONE_FUNCTION) { (void)printf(">[%-25s] %04d", __FILE__, __LINE__); (void)printf(__VA_ARGS__); (void)printf("\r\n"); } } while ((void)0, 0)
#define DEBUGMSG_FUNC_OUT(...) do { if (ZONE_FUNCTION) { (void)printf("<[%-25s] %04d", __FILE__, __LINE__); (void)printf(__VA_ARGS__); (void)printf("\r\n"); } } while ((void)0, 0)
#else
#define DEBUGMSG(cond, ...);
#define DEBUGMSG_RAW(cond, ...);
#define DEBUGMSG_FUNC_IN(...);
#define DEBUGMSG_FUNC_OUT(...);
#endif

#endif /* DEBUGZONES_H_ */
