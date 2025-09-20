#pragma once

#include "PointsGenerator.hpp"

inline void generate_points_json_ofstream(const std::string& file_name, size_t points_count, int groups_count = DEFAULT_GROUPS_COUNT) {
    PointsGenerator generator(groups_count);
    std::ofstream file(file_name);
    file << "[\n";
    for (int i = 0 ; i < points_count; i++) {
        auto [x0, y0] = generator.generate_point();
        auto [x1, y1] = generator.generate_point();
        if (i != 0) file << ",\n";
        file << std::format(
            R"(    {{"x0": {:.10f}, "y0": {:.10f}, "x1": {:.10f}, "y1": {:.10f}}})",
            x0, y0, x1, y1
        );
    }
    file << "\n]";
    file.close();
}

inline void generate_points_json_string(const std::string& file_name, size_t points_count, int groups_count = DEFAULT_GROUPS_COUNT) {
    PointsGenerator generator(groups_count);
    std::string buff;
    auto max_buff_size = 100 * points_count; // Each line can take at max 97 chars
    buff.reserve(max_buff_size);
    buff += "[\n";
    for (int i = 0 ; i < points_count; i++) {
        auto [x0, y0] = generator.generate_point();
        auto [x1, y1] = generator.generate_point();
        if (i != 0) buff += ",\n";
        buff += std::format(
            R"(    {{ "x0": {:.10f}, "y0": {:.10f}, "x1": {:.10f}, "y1": {:.10f} }})",
            x0, y0, x1, y1
        );
    }
    buff += "\n]";

    std::ofstream file(file_name);
    file << buff;
    file.close();
}
