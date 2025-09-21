#pragma once

#include <cstdint>

#ifdef _WIN32

#include <intrin.h>
#include <windows.h>

inline uint64_t get_os_counter() {
    LARGE_INTEGER li;
    QueryPerformanceCounter(&li);
    return li.QuadPart;
}

inline uint64_t get_os_frequency() {
    LARGE_INTEGER li;
    QueryPerformanceFrequency(&li);
    return li.QuadPart;
}

#else

#include <x86intrin.h>
#include <sys/time.h>

inline uint64_t get_os_counter() {
    struct timeval tv;
    gettimeofday(&tv, nullptr);
    return tv.tv_sec * 1000000 + tv.tv_usec;
}

inline uint64_t get_os_frequency() {
    // This counts microseconds, so 1M times per second.
    return 1000000;
}

#endif

inline uint64_t read_tsc() {
    return __rdtsc();
}

inline uint64_t estimate_tsc_frequency(uint64_t period_ms) {
    auto os_freq = get_os_frequency();
    auto needed_os_ticks = os_freq * period_ms / 1000;
    auto os_start = get_os_counter();
    auto target = needed_os_ticks + os_start;
    auto tsc_start = read_tsc();
    uint64_t os_end;
    do {
        os_end = get_os_counter();
    } while (os_end < target);
    // Read one more time so that the two readings are as close as possible.
    os_end = get_os_counter();
    auto tsc_end = read_tsc();
    auto os_ticks = os_end - os_start;
    auto tsc_ticks = tsc_end - tsc_start;
    return tsc_ticks * os_freq / os_ticks;
}
