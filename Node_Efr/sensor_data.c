#include "sensor_data.h"

// Define static global variables
static analogio_analogin_obj_t analog_input;
static smoke_adc_pin global_smoke_pin;
static button_pin global_button_pin;
static alarm_speaker_pin global_speaker_pin;

void init_read_sensor(smoke_adc_pin *smoke_pin, button_pin *btt_pin, alarm_speaker_pin *speaker_pin) {
  // Initialize global variables
  global_smoke_pin = *smoke_pin;
  global_button_pin = *btt_pin;
  global_speaker_pin = *speaker_pin;

  // GPIO init
  GPIO_PinModeSet(global_speaker_pin.port, global_speaker_pin.number, gpioModePushPull, 1); // Set 0 for high, 1 for low
  GPIO_PinModeSet(global_button_pin.port, global_button_pin.number, gpioModeInputPull, 1); // Get state

  // ADC init
  mcu_pin_obj_t pin = { .port = global_smoke_pin.port, .number = global_smoke_pin.number };
  analog_input_initialize(&analog_input, &pin);

  // Init temperature sensor.
  sl_sensor_rht_init();
}

void get_value_sensor(SensorData *data) {
//  data->temperature = 0;
//  data->button_state = 0;
//  data->fire = 0;
//  data->humidity = 0;
//  data->smoke = 0;
//
  uint32_t h=0;
  uint32_t t=0;

  // Measure temperature; units are % and milli-Celsius.
  sl_sensor_rht_get(&h, &t);

  data->humidity =(uint8_t)(h/1000);
  data->temperature =(uint8_t)(t/1000);

  // Smoke
  uint32_t adc_value = get_value_ADC(&analog_input);
  data->smoke =(uint8_t) (adc_value/1000);

  // Button
  uint8_t bt_st = !GPIO_PinInGet(global_button_pin.port, global_button_pin.number); // Digital read
  data->button_state = (uint8_t)bt_st;
}
void on_alarm_speaker(void){
  GPIO_PinModeSet(global_speaker_pin.port, global_speaker_pin.number, gpioModePushPull, 0); // Set 0 for high, 1 for low
}
