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
    send_text('s', 'o', 's');
  }

  template<typename ...Tail>
  void send_text(char head, Tail ...tail)
  {
    send_char(head);
    send_text(tail...);
  }

  void send_text()
  {
    for(auto i=0; i<3; ++i)
    {
      wdg_.reset();
      inter_word_pause();
    }
  }

  void send_char(char c)
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
    wdg_.reset();
    inter_unit_pause();
  }

  void dot()
  {
    wdg_.reset();
    led_.on();
    wait_units(1);
    led_.off();
    wdg_.reset();
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
