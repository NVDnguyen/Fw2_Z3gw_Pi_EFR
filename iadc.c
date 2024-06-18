#include "iadc.h"
#include <stddef.h>  // Include for NULL
#include <stdint.h>  // Include for uint64_t

static uint8_t num_current_input = 0;  // Use static instead of STATIC
volatile uint16_t scan_result[NUM_INPUTS];
volatile uint8_t scan_flag = 0;
IADC_ScanTable_t init_scan_table = IADC_SCANTABLE_DEFAULT;  // Scan Table

// Dummy implementation of supervisor_ticks_ms64
// You should replace this with your actual implementation
uint64_t supervisor_ticks_ms64(void) {
    // This is a placeholder function.
    // Replace this with a function that returns the current system tick in milliseconds.
    return 0;
}

void analog_input_initialize(analogio_analogin_obj_t *self, const mcu_pin_obj_t *pin) {
    uint8_t adc_index;
    if (self->pin == NULL) {
        self->id = NUM_INPUTS + 1;
        for (adc_index = 0; adc_index < NUM_INPUTS; adc_index++) {
            if (init_scan_table.entries[adc_index].includeInScan == false) {
                self->id = adc_index;
                self->pin = pin;
                init_scan_table.entries[adc_index].includeInScan = true;
                init_scan_table.entries[adc_index].negInput = iadcNegInputGnd;
                init_scan_table.entries[adc_index].posInput = IADC_portPinToPosInput(self->pin->port, self->pin->number);
                num_current_input++;
                break;
            }
        }
    }

    if (self->id == NUM_INPUTS + 1) {
        // Raise an error if no available ADC channels
        // Implementation depends on the error handling in your system
        return;
    }

    // Declare init structs
    IADC_Init_t init = IADC_INIT_DEFAULT;
    IADC_AllConfigs_t initAllConfigs = IADC_ALLCONFIGS_DEFAULT;
    IADC_InitScan_t initScan = IADC_INITSCAN_DEFAULT;

    CMU_ClockEnable(cmuClock_IADC0, true);

    // Select clock for IADC
    CMU_ClockSelectSet(cmuClock_IADCCLK, cmuSelect_FSRCO);

    // Modify init structures and initialize
    init.warmup = iadcWarmupKeepWarm;

    // Set the HFSCLK prescale value here
    init.srcClkPrescale = IADC_calcSrcClkPrescale(IADC0, CLK_SRC_ADC_FREQ, 0);

    // Configuration 0 is used by both scan and single conversions by default.
    initAllConfigs.configs[0].reference = iadcCfgReferenceVddx;
    initAllConfigs.configs[0].vRef = 3300;
    initAllConfigs.configs[0].osrHighSpeed = iadcCfgOsrHighSpeed2x;
    initAllConfigs.configs[0].analogGain = iadcCfgAnalogGain1x;

    // Divide CLK_SRC_ADC to set the CLK_ADC frequency
    initAllConfigs.configs[0].adcClkPrescale = IADC_calcAdcClkPrescale(IADC0, CLK_ADC_FREQ, 0, iadcCfgModeNormal, init.srcClkPrescale);

    // Set the SCANFIFODVL flag when there are 8 entries in the scan FIFO.
    initScan.dataValidLevel = _IADC_SCANFIFOCFG_DVL_VALID8;

    // Tag FIFO entry with scan table entry id
    initScan.showId = true;

    // Initialize IADC
    IADC_init(IADC0, &init, &initAllConfigs);

    // Initialize scan
    IADC_initScan(IADC0, &initScan, &init_scan_table);

    if (self->pin->port == gpioPortA) {
        GPIO->ABUSALLOC |= GPIO_ABUSALLOC_AEVEN0_ADC0;
        GPIO->ABUSALLOC |= GPIO_ABUSALLOC_AODD0_ADC0;
    } else if (self->pin->port == gpioPortB) {
        GPIO->BBUSALLOC |= GPIO_BBUSALLOC_BEVEN0_ADC0;
        GPIO->BBUSALLOC |= GPIO_BBUSALLOC_BODD0_ADC0;
    } else {
        GPIO->CDBUSALLOC |= GPIO_CDBUSALLOC_CDEVEN0_ADC0;
        GPIO->CDBUSALLOC |= GPIO_CDBUSALLOC_CDODD0_ADC0;
    }

    // Clear any previous interrupt flags
    IADC_clearInt(IADC0, _IADC_IF_MASK);

    // Enable Scan interrupts
    IADC_enableInt(IADC0, IADC_IEN_SCANTABLEDONE);

    // Enable ADC interrupts
    NVIC_ClearPendingIRQ(IADC_IRQn);
    NVIC_EnableIRQ(IADC_IRQn);
}

bool analog_input_is_deinitialized(analogio_analogin_obj_t *self) {
    return self->pin == NULL;
}

void analog_input_deinitialize(analogio_analogin_obj_t *self) {
    if (num_current_input > 0) {
        num_current_input--;
        if (num_current_input == 0) {
            IADC_reset(IADC0);
        }
    }
    init_scan_table.entries[self->id].includeInScan = false;
    init_scan_table.entries[self->id].posInput = iadcPosInputGnd;
    scan_result[self->id] = 0;
    // Implement the function `common_hal_reset_pin` according to your system's needs
    // common_hal_reset_pin(self->pin);
    self->pin = NULL;
}

void IADC_IRQHandler(void) {
    IADC_Result_t result = {0, 0};

    // While the FIFO count is non-zero
    while (IADC_getScanFifoCnt(IADC0)) {
        // Pull a scan result from the FIFO
        result = IADC_pullScanFifoResult(IADC0);
        scan_result[result.id] = result.data;
        scan_result[result.id] *= 16;
    }
    scan_flag = 1;
    IADC_clearInt(IADC0, IADC_IF_SCANTABLEDONE);
}

uint16_t get_value_ADC(analogio_analogin_obj_t *self) {
    // Start scan
    IADC_command(IADC0, iadcCmdStartScan);

    uint64_t start_ticks = supervisor_ticks_ms64();
    uint64_t current_ticks = start_ticks;

    // Busy-wait until timeout or until we've read enough chars.
    while (current_ticks - start_ticks <= 1000) {
        current_ticks = supervisor_ticks_ms64();
        if (scan_flag == 1) {
            scan_flag = 0;
            break;
        }
        // Implement a background task runner according to your system's needs
        // RUN_BACKGROUND_TASKS;
        // Allow user to break out of a timeout with a KeyboardInterrupt.
        // if (mp_hal_is_interrupted()) {
        //     break;
        // }
    }

    uint16_t ret = scan_result[self->id];
    scan_result[self->id] = 0;
    return ret;
}

float common_hal_analogio_analogin_get_reference_voltage(analogio_analogin_obj_t *self) {
    return 3.3f;
}
