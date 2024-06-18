#ifndef SENSOR_DATA_H
#define SENSOR_DATA_H

#include <stdbool.h>
#ifdef SL_COMPONENT_CATALOG_PRESENT
#include "sl_component_catalog.h"
#endif // SL_COMPONENT_CATALOG_PRESENT
#ifdef SL_CATALOG_CLI_PRESENT
#include "sl_cli.h"
#endif // SL_CATALOG_CLI_PRESENT
#include "sl_sensor_rht.h"
#include "em_gpio.h"
#include "iadc.h"

// Fire, smoke, temp, hum, button, buzzer
typedef struct {
  uint8_t button_state;
  uint8_t fire;
  uint8_t temperature;
  uint8_t humidity;
  uint8_t smoke;
} SensorData;

typedef struct {
  GPIO_Port_TypeDef port;
  uint8_t number;
} smoke_adc_pin;

typedef struct {
  GPIO_Port_TypeDef port;
  uint8_t number;
} button_pin;

typedef struct {
  GPIO_Port_TypeDef port;
  uint8_t number;
} alarm_speaker_pin;

void init_read_sensor(smoke_adc_pin *smoke_pin, button_pin *btt_pin, alarm_speaker_pin *speaker_pin);
void get_value_sensor(SensorData *data);
void on_alarm_speaker(void);



#endif // SENSOR_DATA_H
