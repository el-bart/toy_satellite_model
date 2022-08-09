#pragma once
#include "config.hpp"
#include <util/delay.h>

#include "Led.hpp"
#include "Watchdog.hpp"


struct Core
{
  Core() { led_.off(); }

  template<char ...Text>
  inline void run()
  {
    while(true)
      send_text<Text..., '\0'>();
  }

private:
  template<char Head, char ...Tail>
  inline void send_text()
  {
    wdg_.reset();
    send_char<Head>();
    inter_letter_pause();
    send_text<Tail...>();
  }

  template<char c>
  void send_char();

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

  void end_of_text_pause()
  {
    for(auto i=0; i<3; ++i)
    {
      wdg_.reset();
      inter_word_pause();
    }
  }

  void wait_units(unsigned n)
  {
    for(auto i=0u; i<n; ++i)
    {
      wdg_.reset();
      _delay_ms(100);   // wikipedia suggest 50ms, but it looks too fast on LED
      wdg_.reset();
    }
  }

  Watchdog wdg_;
  Led led_;
};


template<> void Core::send_char<'s'>() { dot();  dot();  dot();  }
template<> void Core::send_char<'o'>() { dash(); dash(); dash(); }
template<> void Core::send_char<' '>() { inter_word_pause(); }

template<>
void Core::send_text<'\0'>()
{
  end_of_text_pause();
}
