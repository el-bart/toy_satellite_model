#pragma once
#include <inttypes.h>
#include <avr/io.h>

constexpr uint32_t kHz=1000L;
constexpr uint32_t MHz=1000L * kHz;
constexpr uint32_t fcpu = (9*MHz + 600*kHz)/8;
#define F_CPU fcpu
