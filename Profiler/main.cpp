#include <iostream>

#define PROFILE

#include "Profiler.hpp"

std::string str;

int rand_size() {
    return std::max(1, rand()) % 100;
}

void B(int depth);

void A(int depth = 1) {
    const auto iterations = 1000;
    const auto size = rand_size();
    profile_scope_with_throughput("A", iterations * size);
    if (depth >= 1000) {
        return;
    }
    for (int i = 0; i < iterations; i++) {
        profile_scope_with_throughput("A Loop", size);
        str += std::string(size, 'A');
    }
    B(depth + 1);
}

void B(int depth) {
    const auto iterations = 1000;
    const auto size = rand_size();
    profile_scope_with_throughput("B", iterations * size);
    for (int i = 0; i < iterations; i++) {
        profile_scope_with_throughput("B Loop", size);
        str += std::string(size, 'B');
    }
    A(depth + 1);
}

int main() {
    srand(read_tsc());
    profiler_data.start_profiling();
    A();
    profiler_data.end_profiling();
    std::cout << profiler_data.report_timing() << "\n\n";
    std::cout << profiler_data.report_throughput() << "\n\n";
}