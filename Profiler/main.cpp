#include <iostream>

#define PROFILE

#include "Profiler.hpp"

std::string str;

int rand_size() {
    return std::max(1, rand()) % 100;
}

void B(int depth);

void A(int depth = 1) {
    profile_scope("A");
    if (depth >= 1000) {
        return;
    }
    for (int i = 0; i < 1000; i++) {
        profile_scope("A Loop");
        const auto size = rand_size();
        str += std::string(size, 'A');
    }
    B(depth + 1);
}

void B(int depth) {
    profile_scope("B");
    for (int i = 0; i < 1000; i++) {
        profile_scope("B Loop");
        const auto size = rand_size();
        str += std::string(size, 'B');
    }
    A(depth + 1);
}

int main() {
    srand(read_tsc());
    profiler_data.start_profiling();
    A();
    profiler_data.end_profiling();
    std::cout << profiler_data.report();
}