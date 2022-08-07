#pragma once
#include <inttypes.h>

struct Led
{
  Led(void) { DDRB |= _BV(1); }
  void on()  { PORTB |=  _BV(1); }
  void off() { PORTB &= ~_BV(1); }
};
