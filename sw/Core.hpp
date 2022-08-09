#pragma once
#include "config.hpp"
#include <util/delay.h>

#include "Led.hpp"
#include "Watchdog.hpp"


struct Core
{
  Core() { led_.off(); }

  void run()
  {
    while(true)
      loop_once();
  }

private:
  void loop_once()
  {
    wdg_.reset();

    led_.on();
    wait100ms(5);

    led_.off();
    wait100ms(5);
  }

  void wait100ms(unsigned n=1)
  {
    for(auto i=0u; i<n; ++i)
    {
      wdg_.reset();
      _delay_ms(100);
    }
  }

  void dash()
  {
  }

  void dot()
  {
  }

  Watchdog wdg_;
  Led led_;
};
