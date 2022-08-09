#pragma once
#include <inttypes.h>
#include <avr/io.h>

constexpr uint32_t kHz=1000ul;
constexpr uint32_t MHz=1000ul * kHz;
constexpr uint32_t fcpu = (128u*kHz)/8u;
#define F_CPU fcpu
