#include <iostream>

#include "EstimateTSCFrequency.hpp"

int main(int argc, char** argv) {
    if (argc != 2) {
        std::cout << "Usage: " << argv[0] << " <period_ms>" << std::endl;
        return 1;
    }

    auto freq = estimate_tsc_frequency(std::stoull(argv[1]));
    std::cout << "Estimated frequency: " << freq << '\n';
}