#include <iostream>

#include "Strategies.hpp"
#include "../RepetitionTester/RepetitionTester.hpp"

#define S(name) { #name, name }

struct Strategy {
    const char* name;
    void (*func)(size_t size, uint64_t* data);
};

Strategy strategies[] = {
    S(fill_random),
    S(fill_CRT_random),
    S(fill_always_taken),
    S(fill_taken_every_2),
    S(fill_taken_every_4),
    S(fill_taken_every_8),
    S(fill_never_taken),
};

void test(size_t n, size_t repetitions) {
    std::vector<uint64_t> v(n);

    auto freq = estimate_tsc_frequency(100);
    auto strategies_count = std::size(strategies);
    std::vector<RepetitionTester> testers;
    testers.reserve(strategies_count);
    for (size_t i = 0; i < strategies_count; ++i) {
        testers.emplace_back(strategies[i].name, freq, n);
    }

    constexpr int step = 100;
    for (size_t _a = 0; _a < repetitions; _a += step) {
        for (size_t _b = 0; _b < step; ++_b) {
            for (size_t i = 0; i < strategies_count; ++i) {
                auto& tester = testers[i];
                strategies[i].func(n, v.data());

                tester.reset_timer();
                tester.start_iter();
                conditional_nop(n, v.data());
                tester.end_iter();
            }
        }
        for (size_t i = 0; i < strategies_count; ++i) {
            std::cout << testers[i].report() << '\n';
        }
    }
}

int main() {
    test(10000000, 1000000000000);
}