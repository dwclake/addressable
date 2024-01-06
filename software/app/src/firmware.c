/*
 *
 */

#define STM32F4

#include "libopencm3/stm32/f4/rcc.h"
#include "libopencm3/stm32/gpio.h"
#include "libopencm3/cm3/systick.h"
#include "libopencm3/cm3/vector.h"

#define CPU_FREQ (84000000)
#define SYSTICK_FREQ (1000)

#define LED_PORT (GPIOA)
#define LED_PIN (GPIO5)
#define BTN_PORT (GPIOC)
#define BTN_PIN (GPIO13)

static void rcc_setup(void) {
    rcc_clock_setup_pll(&rcc_hsi_configs[RCC_CLOCK_3V3_84MHZ]);
}

static void gpio_setup(void) {
    rcc_periph_clock_enable(RCC_GPIOA);
    rcc_periph_clock_enable(RCC_GPIOC);

    gpio_mode_setup(
        LED_PORT, 
        GPIO_MODE_OUTPUT, 
        GPIO_PUPD_NONE, 
        LED_PIN
        );
    
    gpio_mode_setup(
        BTN_PORT, 
        GPIO_MODE_INPUT, 
        GPIO_PUPD_PULLDOWN, 
        BTN_PIN
        );
}

volatile uint64_t ticks = 0;
void sys_tick_handler(void) {
    ticks++;
}

static uint64_t get_ticks(void) {
    return ticks;
}

static void systick_setup(void) {
    systick_set_frequency(SYSTICK_FREQ, CPU_FREQ);
    systick_counter_enable();
    systick_interrupt_enable();
}

int main(void) {
    /* Setup */
    rcc_setup();
    gpio_setup();
    systick_setup();

    uint64_t start_time = get_ticks();

    uint32_t milliseconds = 1000;

    /* Loop */
    while (1) {
        if (get_ticks() - start_time >= milliseconds) {
            gpio_toggle(LED_PORT, LED_PIN);
            start_time = get_ticks();
        }

        if ((gpio_get(BTN_PORT, BTN_PIN) & BTN_PIN) == 0) {
            milliseconds ^= 500;
        }
    }

    return 0;
}
