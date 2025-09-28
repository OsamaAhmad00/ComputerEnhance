#pragma once

#include <cstdint>
#include <ctime>
#include <random>

extern "C" void conditional_nop(size_t n, uint64_t* data);

inline void fill_taken_every_x(size_t n, uint64_t* data, size_t x) {
    for (size_t i = 0; i < n; i++) {
        data[i] = i % x;
    }
}

inline void fill_random(size_t n, uint64_t* data) {
    std::random_device rd;
    std::mt19937_64 gen(rd());
    std::uniform_int_distribution<uint64_t> dist;
    for (size_t i = 0; i < n; i++) {
        data[i] = dist(gen);
    }
}

inline void fill_CRT_random(size_t n, uint64_t* data) {
    srand(time(nullptr));
    for (size_t i = 0; i < n; i++) {
        data[i] = rand();
    }
}

static void fill_always_taken(size_t n, uint64_t* data) {
    for (size_t i = 0; i < n; i++) {
        data[i] = 1;
    }
}

inline void fill_taken_every_2(size_t n, uint64_t* data) {
    return fill_taken_every_x(n, data, 2);
}

inline void fill_taken_every_4(size_t n, uint64_t* data) {
    return fill_taken_every_x(n, data, 2);
}

inline void fill_taken_every_8(size_t n, uint64_t* data) {
    return fill_taken_every_x(n, data, 2);
}

inline void fill_never_taken(size_t n, uint64_t* data) {
    for (size_t i = 0; i < n; i++) {
        data[i] = 0;
    }
}