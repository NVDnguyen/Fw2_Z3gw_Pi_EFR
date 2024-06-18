#ifndef IADC_H
#define IADC_H

#include <stdint.h>
#include <stdbool.h>
#include "em_iadc.h"
#include "em_gpio.h"
#include "em_cmu.h"

// Set CLK_ADC to 10MHz
#define CLK_SRC_ADC_FREQ 20000000  // CLK_SRC_ADC
#define CLK_ADC_FREQ 10000000      // CLK_ADC - 10 MHz max in normal mode

// Number of scan channels
#define NUM_INPUTS 8

typedef struct {
    const GPIO_Port_TypeDef port;
    uint8_t number;
} mcu_pin_obj_t;

typedef struct {
    const mcu_pin_obj_t *pin;
    uint8_t id;
} analogio_analogin_obj_t;

extern volatile uint16_t scan_result[NUM_INPUTS];
extern volatile uint8_t scan_flag;
extern IADC_ScanTable_t init_scan_table;

// Function declarations

void analog_input_initialize(analogio_analogin_obj_t *self, const mcu_pin_obj_t *pin);
bool analog_input_is_deinitialized(analogio_analogin_obj_t *self);
void analog_input_deinitialize(analogio_analogin_obj_t *self);
void IADC_IRQHandler(void);
uint16_t get_value_ADC(analogio_analogin_obj_t *self);
float common_hal_analogio_analogin_get_reference_voltage(analogio_analogin_obj_t *self);

#endif // IADC_H
