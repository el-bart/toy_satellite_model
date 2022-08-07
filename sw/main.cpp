#include "config.hpp"
#include <avr/io.h>
#include <util/delay.h>
#include <inttypes.h>

#include "Led.hpp"
#include "Watchdog.hpp"

int main(void)
{
  Watchdog wdg;
  Led led;

  wdg.reset();

  // TODO: main loop
  while(true)
  {
    led.on();
    for(auto i=0; i<5; ++i)
    {
      wdg.reset();
      _delay_ms(100);
    }

    led.off();
    for(auto i=0; i<5; ++i)
    {
      wdg.reset();
      _delay_ms(100);
    }
  }
}
