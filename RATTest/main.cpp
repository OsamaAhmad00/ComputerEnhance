#include <iostream>
#include <vector>

#include "../RepetitionTester/RepetitionTester.hpp"

#define F(name) { #name, name }

struct Function {
    const char* name;
    void (*func)(size_t);
};

#ifdef _WIN32

extern "C" void dependent_adds_win(size_t n);
extern "C" void independent_adds_win(size_t n);

Function functions[] = {
    F(dependent_adds_win),
    F(independent_adds_win),
};

#else

extern "C" void dependent_adds_linux(size_t n);
extern "C" void independent_adds_linux(size_t n);

Function functions[] = {
    F(dependent_adds_linux),
    F(independent_adds_linux),
};

#endif

void test(size_t n, size_t repetitions) {
    auto freq = estimate_tsc_frequency(100);
    auto functions_count = std::size(functions);
    std::vector<RepetitionTester> testers;
    testers.reserve(functions_count);
    for (size_t i = 0; i < functions_count; ++i) {
        testers.emplace_back(functions[i].name, freq, n);
    }

    constexpr int step = 1000;
    for (size_t _a = 0; _a < repetitions; _a += step) {
        for (size_t _b = 0; _b < step; ++_b) {
            for (size_t i = 0; i < functions_count; ++i) {
                auto& tester = testers[i];

                tester.reset_timer();
                tester.start_iter();
                functions[i].func(n);
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

