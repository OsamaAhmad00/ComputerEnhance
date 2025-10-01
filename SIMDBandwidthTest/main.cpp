#include <iostream>
#include <vector>

#include "../RepetitionTester/RepetitionTester.hpp"

#define F(name) { #name, name }

extern "C" void two_reads_1_byte(size_t n, std::byte* data);
extern "C" void two_reads_2_bytes(size_t n, std::byte* data);
extern "C" void two_reads_4_bytes(size_t n, std::byte* data);
extern "C" void two_reads_8_bytes(size_t n, std::byte* data);
extern "C" void two_reads_16_bytes(size_t n, std::byte* data);
extern "C" void two_reads_32_bytes(size_t n, std::byte* data);

struct Function {
    const char* name;
    void (*func)(size_t, std::byte*);
};

Function functions[] = {
    F(two_reads_1_byte),
    F(two_reads_2_bytes),
    F(two_reads_4_bytes),
    F(two_reads_8_bytes),
    F(two_reads_16_bytes),
    F(two_reads_32_bytes),
};

void test(size_t n, size_t repetitions) {
    auto freq = estimate_tsc_frequency(100);
    auto functions_count = std::size(functions);
    std::vector<RepetitionTester> testers;
    testers.reserve(functions_count);
    for (size_t i = 0; i < functions_count; ++i) {
        testers.emplace_back(functions[i].name, freq, n);
    }

    constexpr int max_width = 32 * 2;
    std::byte arr[max_width];

    constexpr int step = 100;
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
    test(100000000, 1000000000000);
}