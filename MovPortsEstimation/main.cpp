#include <iostream>
#include <vector>

#include "../RepetitionTester/RepetitionTester.hpp"

#define F(name) { #name, name }

extern "C" void load1(size_t n, uint64_t* data);
extern "C" void load2(size_t n, uint64_t* data);
extern "C" void load3(size_t n, uint64_t* data);
extern "C" void load4(size_t n, uint64_t* data);

extern "C" void store1(size_t n, uint64_t* data);
extern "C" void store2(size_t n, uint64_t* data);
extern "C" void store3(size_t n, uint64_t* data);
extern "C" void store4(size_t n, uint64_t* data);

struct Function {
    const char* name;
    void (*func)(size_t, uint64_t*);
};

Function functions[] = {
    F(load1),
    F(load2),
    F(load3),
    F(load4),
    F(store1),
    F(store2),
    F(store3),
    F(store4),
};

void test(size_t n, size_t repetitions) {
    auto freq = estimate_tsc_frequency(100);
    auto functions_count = std::size(functions);
    std::vector<RepetitionTester> testers;
    testers.reserve(functions_count);
    for (size_t i = 0; i < functions_count; ++i) {
        testers.emplace_back(functions[i].name, freq, n);
    }

    uint64_t dummy;
    constexpr int step = 1000;
    for (size_t _a = 0; _a < repetitions; _a += step) {
        for (size_t _b = 0; _b < step; ++_b) {
            for (size_t i = 0; i < functions_count; ++i) {
                auto& tester = testers[i];

                tester.reset_timer();
                tester.start_iter();
                functions[i].func(n, &dummy);
                tester.end_iter();
            }
        }
        for (size_t i = 0; i < functions_count; ++i) {
            std::cout << testers[i].report() << '\n';
        }
    }
}

int main() {
    test(10000000, 1000000000000);
}