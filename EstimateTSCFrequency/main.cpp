#include <iostream>

#include "EstimateTSCFrequency.hpp"

int main(int argc, char** argv) {
    if (argc != 2) {
        std::cout << "Usage: " << argv[0] << " <period_ms>" << std::endl;
        return 1;
    }

    std::cout << "Operating system frequency: " << get_os_frequency() << '\n';
    auto freq = estimate_tsc_frequency(std::stoull(argv[1]));
    std::cout << "Estimated TSC frequency: " << freq << '\n';
}