#include <iostream>
#include <vector>

#include "../RepetitionTester/RepetitionTester.hpp"

#define F(name) { #name, name }

extern "C" void touch_2KB(size_t n, std::byte* data);
extern "C" void touch_2KB_6_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_8_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_10_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_12_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_14_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_16_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_18_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_19_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_20_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_21_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_22_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_24_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_32_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_40_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_48_loads(size_t n, std::byte* data);
extern "C" void touch_2KB_64_loads(size_t n, std::byte* data);
extern "C" void touch_4KB(size_t n, std::byte* data);
extern "C" void touch_8KB(size_t n, std::byte* data);
extern "C" void touch_16KB(size_t n, std::byte* data);
extern "C" void touch_32KB(size_t n, std::byte* data);
extern "C" void touch_64KB(size_t n, std::byte* data);
extern "C" void touch_128KB(size_t n, std::byte* data);
extern "C" void touch_256KB(size_t n, std::byte* data);
extern "C" void touch_512KB(size_t n, std::byte* data);
extern "C" void touch_1MB(size_t n, std::byte* data);
extern "C" void touch_2MB(size_t n, std::byte* data);
extern "C" void touch_4MB(size_t n, std::byte* data);
extern "C" void touch_8MB(size_t n, std::byte* data);
extern "C" void touch_16MB(size_t n, std::byte* data);
extern "C" void touch_32MB(size_t n, std::byte* data);
extern "C" void touch_64MB(size_t n, std::byte* data);
extern "C" void touch_128MB(size_t n, std::byte* data);
extern "C" void touch_256MB(size_t n, std::byte* data);
extern "C" void touch_512MB(size_t n, std::byte* data);
extern "C" void touch_1GB(size_t n, std::byte* data);

struct Function {
    const char* name;
    void (*func)(size_t, std::byte*);
};

Function functions[] = {
    F(touch_2KB),
    F(touch_2KB_6_loads),
    F(touch_2KB_8_loads),
    F(touch_2KB_10_loads),
    F(touch_2KB_12_loads),
    F(touch_2KB_14_loads),
    F(touch_2KB_16_loads),
    F(touch_2KB_18_loads),
    F(touch_2KB_19_loads),
    F(touch_2KB_20_loads),
    F(touch_2KB_21_loads),
    F(touch_2KB_22_loads),
    F(touch_2KB_24_loads),
    F(touch_2KB_32_loads),
    F(touch_2KB_40_loads),
    F(touch_2KB_48_loads),
    F(touch_2KB_64_loads),
    F(touch_4KB),
    F(touch_8KB),
    F(touch_16KB),
    F(touch_32KB),
    F(touch_64KB),
    F(touch_128KB),
    F(touch_256KB),
    F(touch_512KB),
    F(touch_1MB),
    F(touch_2MB),
    F(touch_4MB),
    F(touch_8MB),
    F(touch_16MB),
    F(touch_32MB),
    F(touch_64MB),
    F(touch_128MB),
    F(touch_256MB),
    F(touch_512MB),
    F(touch_1GB),
};

constexpr uint64_t max_width = 1ULL << 30;
std::byte arr[max_width];

void test(size_t n, size_t repetitions) {
    auto freq = estimate_tsc_frequency(100);
    auto functions_count = std::size(functions);
    std::vector<RepetitionTester> testers;
    testers.reserve(functions_count);
    for (size_t i = 0; i < functions_count; ++i) {
        testers.emplace_back(functions[i].name, freq, n);
    }

    constexpr int step = 50;
    for (size_t _a = 0; _a < repetitions; _a += step) {
        for (size_t _b = 0; _b < step; ++_b) {
            for (size_t i = 0; i < functions_count; ++i) {
                auto& tester = testers[i];

                tester.reset_timer();
                tester.start_iter();
                functions[i].func(n, arr);
                tester.end_iter();
            }
        }
        for (size_t i = 0; i < functions_count; ++i) {
            std::cout << testers[i].report() << '\n';
        }
    }
}

int main() {
    test(1 << 30, 1000000000000);
}