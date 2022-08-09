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
    send('s');
    send('o');
    send('s');
    inter_word_pause();
  }

  void send(char c)
  {
    if(c == 's')
    {
      dot();
      dot();
      dot();
      inter_letter_pause();
      return;
    }
    if(c == 'o')
    {
      dash();
      dash();
      dash();
      inter_letter_pause();
      return;
    }
  }

  void dash()
  {
    wdg_.reset();
    led_.on();
    wait_units(3);
    led_.off();
    inter_unit_pause();
  }

  void dot()
  {
    wdg_.reset();
    led_.on();
    wait_units(1);
    led_.off();
    inter_unit_pause();
  }

  void inter_unit_pause()   { wait_units(1); wdg_.reset(); }
  void inter_letter_pause() { wait_units(3); wdg_.reset(); }
  void inter_word_pause()   { wait_units(7); wdg_.reset(); }

  void wait_units(unsigned n)
  {
    for(auto i=0u; i<n; ++i)
      _delay_ms(50);
  }

  Watchdog wdg_;
  Led led_;
};
