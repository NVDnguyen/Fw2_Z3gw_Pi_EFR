#include "sl_event_handler.h"

#include "em_chip.h"
#include "sl_device_init_nvic.h"
#include "sl_board_init.h"
#include "sl_device_init_dcdc.h"
#include "sl_device_init_lfxo.h"
#include "sl_hfxo_manager.h"
#include "sl_device_init_hfxo.h"
#include "sl_device_init_clocks.h"
#include "sl_device_init_emu.h"
#include "pa_conversions_efr32.h"
#include "sl_rail_util_power_manager_init.h"
#include "sl_rail_util_pti.h"
#include "zigbee_app_framework_common.h"
#include "zigbee-secure-key-storage-upgrade.h"
#include "btl_interface.h"
#include "sl_board_control.h"
#include "sl_sleeptimer.h"
#include "sl_debug_swo.h"
#include "gpiointerrupt.h"
#include "sl_i2cspm_instances.h"
#include "sl_iostream_init_eusart_instances.h"
#include "hal.h"
#include "sl_mbedtls.h"
#include "nvm3_default.h"
#include "sl_simple_button_instances.h"
#include "sl_simple_led_instances.h"
#include "sl_cli_instances.h"
#include "psa/crypto.h"
#include "sl_iostream_init_instances.h"
#include "sl_power_manager.h"
#include "sl_cos.h"

void sl_platform_init(void)
{
  CHIP_Init();
  sl_device_init_nvic();
  sl_board_preinit();
  sl_device_init_dcdc();
  sl_device_init_lfxo();
  sl_hfxo_manager_init_hardware();
  sl_device_init_hfxo();
  sl_device_init_clocks();
  sl_device_init_emu();
  sl_board_init();
  bootloader_init();
  halInit();
  nvm3_initDefault();
  sl_power_manager_init();
}

void sl_driver_init(void)
{
  sl_debug_swo_init();
  GPIOINT_Init();
  sl_i2cspm_init_instances();
  sl_simple_button_init_instances();
  sl_simple_led_init_instances();
  sl_cos_send_config();
}

void sl_service_init(void)
{
  sl_board_configure_vcom();
  sl_sleeptimer_init();
  sl_hfxo_manager_init();
  sl_mbedtls_init();
  psa_crypto_init();
  sl_iostream_init_instances();
  sl_cli_instances_init();
}

void sl_stack_init(void)
{
  sl_rail_util_pa_init();
  sl_rail_util_power_manager_init();
  sl_rail_util_pti_init();
  sli_zigbee_stack_init_callback();
  sli_zigbee_app_framework_init_callback();
  sli_zigbee_app_framework_sleep_init();
  sli_zb_sec_man_upgrade_key_storage();
}

void sl_internal_app_init(void)
{
}

void sl_platform_process_action(void)
{
}

void sl_service_process_action(void)
{
  sl_cli_instances_tick();
}

void sl_stack_process_action(void)
{
  sli_zigbee_stack_tick_callback();
  sli_zigbee_app_framework_tick_callback();
}

void sl_internal_app_process_action(void)
{
}

void sl_iostream_init_instances(void)
{
  sl_iostream_eusart_init_instances();
}

