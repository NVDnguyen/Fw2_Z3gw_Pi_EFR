/***************************************************************************//**
 * @file zigbee_common_callback_dispatcher.c
 * @brief ZigBee common dispatcher definitions.
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

#include PLATFORM_HEADER
#include "stack/include/ember.h"
#include "zigbee_app_framework_common.h"
#include "zigbee_common_callback_dispatcher.h"

void sli_zigbee_af_event_init(void)
{
  sli_zigbee_af_zcl_framework_core_init_events_callback(SL_ZIGBEE_INIT_LEVEL_EVENT);
  sli_zigbee_af_service_discovery_init_events_callback(SL_ZIGBEE_INIT_LEVEL_EVENT);
  sli_zigbee_af_color_control_server_init_callback(SL_ZIGBEE_INIT_LEVEL_EVENT);
  emberAfPluginGreenPowerClientInitCallback(SL_ZIGBEE_INIT_LEVEL_EVENT);
  emberAfPluginInterpanInitCallback(SL_ZIGBEE_INIT_LEVEL_EVENT);
  sli_zigbee_af_network_steering_init_callback(SL_ZIGBEE_INIT_LEVEL_EVENT);
  emberAfPluginReportingInitCallback(SL_ZIGBEE_INIT_LEVEL_EVENT);
  sli_zigbee_af_scan_dispatch_init_callback(SL_ZIGBEE_INIT_LEVEL_EVENT);
  sli_zigbee_af_update_tc_link_key_begin_tc_link_key_update_init(SL_ZIGBEE_INIT_LEVEL_EVENT);
  sli_zigbee_watchdog_refresh_handler_init(SL_ZIGBEE_INIT_LEVEL_EVENT);
  sli_zigbee_af_zll_identify_server_init_callback(SL_ZIGBEE_INIT_LEVEL_EVENT);
}

void sli_zigbee_af_local_data_init(void)
{
  emberAfPluginCountersInitCallback(SL_ZIGBEE_INIT_LEVEL_LOCAL_DATA);
  emberAfPluginGreenPowerClientInitCallback(SL_ZIGBEE_INIT_LEVEL_LOCAL_DATA);
  emberAfPluginInterpanInitCallback(SL_ZIGBEE_INIT_LEVEL_LOCAL_DATA);
}

void sli_zigbee_af_initDone(void)
{
  sli_zigbee_af_initCallback(SL_ZIGBEE_INIT_LEVEL_DONE);
  sli_zigbee_zcl_cli_init(SL_ZIGBEE_INIT_LEVEL_DONE);
  emberAfInit(SL_ZIGBEE_INIT_LEVEL_DONE);
  emberAfPluginGreenPowerClientInitCallback(SL_ZIGBEE_INIT_LEVEL_DONE);
  emberAfPluginNetworkCreatorSecurityInitCallback(SL_ZIGBEE_INIT_LEVEL_DONE);
  emberAfPluginReportingInitCallback(SL_ZIGBEE_INIT_LEVEL_DONE);
  emberAfPluginZllCommissioningCommonInitCallback(SL_ZIGBEE_INIT_LEVEL_DONE);
  sli_zigbee_af_network_init(SL_ZIGBEE_INIT_LEVEL_DONE);
}


void sli_zigbee_af_tick(void)
{
}
