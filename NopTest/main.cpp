#include <iostream>
#include <vector>

#include "../EstimateTSCFrequency/EstimateTSCFrequency.hpp"
#include "../RepetitionTester/RepetitionTester.hpp"

// The more NOPs, the worse the performance.
// The more the size of a single nop, the worse the performance.
// Given the same number of bytes, less NOPs is better. In other
//  words, a single 1-byte NOP is better than 3 1-bytes NOPs
extern "C" void NOP0(uint64_t n);
extern "C" void NOP1x1(uint64_t n);
extern "C" void NOP3x1(uint64_t n);
extern "C" void NOP1x3(uint64_t n);
extern "C" void NOP3x3(uint64_t n);
extern "C" void NOP1x9(uint64_t n);

struct Test {
    void (*func)(uint64_t);
    const char* name;
};

Test tests[] = {
    { NOP0, "NOP0" },
    { NOP1x1, "NOP1x1" },
    { NOP3x1, "NOP3x1" },
    { NOP3x1, "NOP1x3" },
    { NOP3x3, "NOP3x3" },
    { NOP1x9, "NOP1x9" },
};

int main() {
    constexpr auto input_size = 1000'000ULL;
    auto freq = estimate_tsc_frequency(100);

    constexpr auto tests_count = std::size(tests);
    std::vector<RepetitionTester> testers;
    testers.reserve(tests_count);
    for (int i = 0; i < tests_count; ++i) {
        testers.emplace_back(tests[i].name, freq, input_size);
    }

    constexpr auto n = 1000000;
    constexpr auto step = 1000;
    for (int _ = 0; _ < n; _ += step) {
        for (int __ = 0; __ < step; ++__) {
            for (int i = 0; i < tests_count; ++i) {
                testers[i].reset_timer();

                testers[i].start_iter();
                tests[i].func(input_size);
                testers[i].end_iter();
            }
        }

        for (int i = 0; i < tests_count; ++i) {
            std::cout << testers[i].report() << '\n';
        }
    }
}