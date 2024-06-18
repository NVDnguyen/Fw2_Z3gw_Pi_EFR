/***************************************************************************//**
 * @file  zap-event.h
 * @brief Generated file for zcl events using ZAP. Do not update file manually.
 *******************************************************************************
 * # License
 * <b>Copyright 2020 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/


#ifdef SL_COMPONENT_CATALOG_PRESENT
#include "sl_component_catalog.h"
#endif

#ifdef SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT
#include "af.h"

#define EMBER_AF_GENERATED_UC_EVENTS_DEF \
sl_zigbee_event_t emberAfIdentifyClusterServerTickCallbackEvent1; \
sl_zigbee_event_t emberAfOnOffClusterServerTickCallbackEvent1; \
sl_zigbee_event_t emberAfLevelControlClusterServerTickCallbackEvent1; \
sl_zigbee_event_t emberAfOtaBootloadClusterClientTickCallbackEvent1; \
sl_zigbee_event_t emberAfIdentifyClusterServerTickCallbackEvent2; \
sl_zigbee_event_t emberAfOnOffClusterServerTickCallbackEvent2; \
sl_zigbee_event_t emberAfLevelControlClusterServerTickCallbackEvent2; \
sl_zigbee_event_t emberAfOtaBootloadClusterClientTickCallbackEvent2; \
sl_zigbee_event_t emberAfColorControlClusterServerTickCallbackEvent2; \


#define EMBER_AF_GENERATED_UC_EVENTS_INIT \
extern void emberAfIdentifyClusterServerTickCallback(uint8_t endpoint); \
extern void emberAfOnOffClusterServerTickCallback(uint8_t endpoint); \
extern void emberAfLevelControlClusterServerTickCallback(uint8_t endpoint); \
extern void emberAfOtaBootloadClusterClientTickCallback(uint8_t endpoint); \
extern void emberAfColorControlClusterServerTickCallback(uint8_t endpoint); \
sl_zigbee_endpoint_event_init(&emberAfIdentifyClusterServerTickCallbackEvent1, (void *)emberAfIdentifyClusterServerTickCallback, 1); \
sl_zigbee_endpoint_event_init(&emberAfOnOffClusterServerTickCallbackEvent1, (void *)emberAfOnOffClusterServerTickCallback, 1); \
sl_zigbee_endpoint_event_init(&emberAfLevelControlClusterServerTickCallbackEvent1, (void *)emberAfLevelControlClusterServerTickCallback, 1); \
sl_zigbee_endpoint_event_init(&emberAfOtaBootloadClusterClientTickCallbackEvent1, (void *)emberAfOtaBootloadClusterClientTickCallback, 1); \
sl_zigbee_endpoint_event_init(&emberAfIdentifyClusterServerTickCallbackEvent2, (void *)emberAfIdentifyClusterServerTickCallback, 2); \
sl_zigbee_endpoint_event_init(&emberAfOnOffClusterServerTickCallbackEvent2, (void *)emberAfOnOffClusterServerTickCallback, 2); \
sl_zigbee_endpoint_event_init(&emberAfLevelControlClusterServerTickCallbackEvent2, (void *)emberAfLevelControlClusterServerTickCallback, 2); \
sl_zigbee_endpoint_event_init(&emberAfOtaBootloadClusterClientTickCallbackEvent2, (void *)emberAfOtaBootloadClusterClientTickCallback, 2); \
sl_zigbee_endpoint_event_init(&emberAfColorControlClusterServerTickCallbackEvent2, (void *)emberAfColorControlClusterServerTickCallback, 2); \

// sl_zigbee_event_context_t structs used to populate the sli_zigbee_app_event_context table
#define EMBER_AF_GENERATED_UC_EVENT_CONTEXT \
{ 1, 0x3, false, EMBER_AF_LONG_POLL, EMBER_AF_OK_TO_SLEEP, &emberAfIdentifyClusterServerTickCallbackEvent1 },     \
{ 1, 0x6, false, EMBER_AF_LONG_POLL, EMBER_AF_OK_TO_SLEEP, &emberAfOnOffClusterServerTickCallbackEvent1 },     \
{ 1, 0x8, false, EMBER_AF_LONG_POLL, EMBER_AF_OK_TO_SLEEP, &emberAfLevelControlClusterServerTickCallbackEvent1 },     \
{ 1, 0x19, true, EMBER_AF_LONG_POLL, EMBER_AF_OK_TO_SLEEP, &emberAfOtaBootloadClusterClientTickCallbackEvent1 },     \
{ 2, 0x3, false, EMBER_AF_LONG_POLL, EMBER_AF_OK_TO_SLEEP, &emberAfIdentifyClusterServerTickCallbackEvent2 },     \
{ 2, 0x6, false, EMBER_AF_LONG_POLL, EMBER_AF_OK_TO_SLEEP, &emberAfOnOffClusterServerTickCallbackEvent2 },     \
{ 2, 0x8, false, EMBER_AF_LONG_POLL, EMBER_AF_OK_TO_SLEEP, &emberAfLevelControlClusterServerTickCallbackEvent2 },     \
{ 2, 0x19, true, EMBER_AF_LONG_POLL, EMBER_AF_OK_TO_SLEEP, &emberAfOtaBootloadClusterClientTickCallbackEvent2 },     \
{ 2, 0x300, false, EMBER_AF_LONG_POLL, EMBER_AF_OK_TO_SLEEP, &emberAfColorControlClusterServerTickCallbackEvent2 },     \

#define EMBER_AF_GENERATED_UC_EVENT_CONTEXT_COUNT 9

#endif // SL_CATALOG_ZIGBEE_ZCL_FRAMEWORK_CORE_PRESENT
