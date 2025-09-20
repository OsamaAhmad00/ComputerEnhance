#include <fstream>
#include <iostream>

#include "GenerateJSON.hpp"

int main(int argc, char** argv) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <output_file_name> <points_count>\n";
        return 1;
    }

    generate_points_json_ofstream(argv[1], std::stoull(argv[2]));
}