/***************************************************************************//**
 * @file sl_cluster_service_gen.c
 * @brief Cluster Service generated code.
 *******************************************************************************
 * # License
 * <b>Copyright 2021 Silicon Laboratories Inc. www.silabs.com</b>
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

// This template contains a pre-generated ZCL command specific init block of the 
// service functions.

#include PLATFORM_HEADER
#include "sl_service_function.h"
#include "af.h"


extern uint32_t emberAfBasicClusterServerCommandParse(sl_service_opcode_t opcode,
                                                sl_service_function_context_t *context);
extern uint32_t emberAfColorControlClusterServerCommandParse(sl_service_opcode_t opcode,
                                                sl_service_function_context_t *context);
extern uint32_t emberAfGreenPowerClusterClientCommandParse(sl_service_opcode_t opcode,
                                                sl_service_function_context_t *context);
extern uint32_t emberAfGroupsClusterServerCommandParse(sl_service_opcode_t opcode,
                                                sl_service_function_context_t *context);
extern uint32_t emberAfIdentifyClusterServerCommandParse(sl_service_opcode_t opcode,
                                                sl_service_function_context_t *context);
extern uint32_t emberAfLevelControlClusterServerCommandParse(sl_service_opcode_t opcode,
                                                sl_service_function_context_t *context);
extern uint32_t emberAfOnOffClusterServerCommandParse(sl_service_opcode_t opcode,
                                                sl_service_function_context_t *context);
extern uint32_t emberAfScenesClusterServerCommandParse(sl_service_opcode_t opcode,
                                                sl_service_function_context_t *context);
extern uint32_t emberAfZllIdentifyClusterServerCommandParse(sl_service_opcode_t opcode,
                                                sl_service_function_context_t *context);
extern uint32_t emberAfZllOnOffClusterServerCommandParse(sl_service_opcode_t opcode,
                                                sl_service_function_context_t *context);
extern uint32_t emberAfZllScenesClusterServerCommandParse(sl_service_opcode_t opcode,
                                                sl_service_function_context_t *context);
extern uint32_t emberAfZllCommissioningClusterServerCommandParse(sl_service_opcode_t opcode,
                                                sl_service_function_context_t *context);


const sl_service_function_entry_t sli_cluster_service_entries[] = {
  { SL_SERVICE_FUNCTION_TYPE_ZCL_COMMAND, 0x0000, (NOT_MFG_SPECIFIC | (SL_CLUSTER_SERVICE_SIDE_SERVER << 16)), emberAfBasicClusterServerCommandParse },
  { SL_SERVICE_FUNCTION_TYPE_ZCL_COMMAND, 0x0300, (NOT_MFG_SPECIFIC | (SL_CLUSTER_SERVICE_SIDE_SERVER << 16)), emberAfColorControlClusterServerCommandParse },
  { SL_SERVICE_FUNCTION_TYPE_ZCL_COMMAND, 0x0021, (NOT_MFG_SPECIFIC | (SL_CLUSTER_SERVICE_SIDE_CLIENT << 16)), emberAfGreenPowerClusterClientCommandParse },
  { SL_SERVICE_FUNCTION_TYPE_ZCL_COMMAND, 0x0004, (NOT_MFG_SPECIFIC | (SL_CLUSTER_SERVICE_SIDE_SERVER << 16)), emberAfGroupsClusterServerCommandParse },
  { SL_SERVICE_FUNCTION_TYPE_ZCL_COMMAND, 0x0003, (NOT_MFG_SPECIFIC | (SL_CLUSTER_SERVICE_SIDE_SERVER << 16)), emberAfIdentifyClusterServerCommandParse },
  { SL_SERVICE_FUNCTION_TYPE_ZCL_COMMAND, 0x0008, (NOT_MFG_SPECIFIC | (SL_CLUSTER_SERVICE_SIDE_SERVER << 16)), emberAfLevelControlClusterServerCommandParse },
  { SL_SERVICE_FUNCTION_TYPE_ZCL_COMMAND, 0x0006, (NOT_MFG_SPECIFIC | (SL_CLUSTER_SERVICE_SIDE_SERVER << 16)), emberAfOnOffClusterServerCommandParse },
  { SL_SERVICE_FUNCTION_TYPE_ZCL_COMMAND, 0x0005, (NOT_MFG_SPECIFIC | (SL_CLUSTER_SERVICE_SIDE_SERVER << 16)), emberAfScenesClusterServerCommandParse },
  { SL_SERVICE_FUNCTION_TYPE_ZCL_COMMAND, 0x0003, (NOT_MFG_SPECIFIC | (SL_CLUSTER_SERVICE_SIDE_SERVER << 16)), emberAfZllIdentifyClusterServerCommandParse },
  { SL_SERVICE_FUNCTION_TYPE_ZCL_COMMAND, 0x0006, (NOT_MFG_SPECIFIC | (SL_CLUSTER_SERVICE_SIDE_SERVER << 16)), emberAfZllOnOffClusterServerCommandParse },
  { SL_SERVICE_FUNCTION_TYPE_ZCL_COMMAND, 0x0005, (NOT_MFG_SPECIFIC | (SL_CLUSTER_SERVICE_SIDE_SERVER << 16)), emberAfZllScenesClusterServerCommandParse },
  { SL_SERVICE_FUNCTION_TYPE_ZCL_COMMAND, 0x1000, (NOT_MFG_SPECIFIC | (SL_CLUSTER_SERVICE_SIDE_SERVER << 16)), emberAfZllCommissioningClusterServerCommandParse },
  };
