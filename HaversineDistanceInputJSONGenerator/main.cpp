#include <cassert>
#include <chrono>
#include <fstream>
#include <iostream>
#include <sstream>
#include <random>
#include <format>

constexpr static auto DEFAULT_GROUPS_COUNT = 16;

std::random_device rd;

class PointsGenerator {

    // When averaging calculations involving uniformly distributed
    // random numbers, large inputs will always converge to a predictable
    // value due to the law of large numbers. To introduce variability,
    // generate a small set of random numbers per run (e.g., 16), compute
    // a random distance for each, and derive your final "random" values by
    // selecting a point within the interval [that number ± its distance].

public:

    // Longitude
    constexpr static auto x_min = -180.0;
    constexpr static auto x_max = 180.0;
    // Latitude
    constexpr static auto y_min = -90.0;
    constexpr static auto y_max = 90.0;

    struct Point {
        double x;
        double y;
    };

private:

    struct Group {
        double x_min;
        double x_max;
        double y_min;
        double y_max;
    };

    std::mt19937 index_gen;
    std::uniform_int_distribution<int> index_distribution;

    std::mt19937 x_gen;
    std::mt19937 y_gen;
    std::uniform_real_distribution<double> x_distribution;
    std::uniform_real_distribution<double> y_distribution;

    std::vector<Group> groups;

    static double wrap_around(double value, double min, double max) {
        if (value < min) return max - (min - value);
        if (value > max) return min + (value - max);
        return value;
    }

public:

    static void verify_points_in_range(const int tests_count = 1000000) {
        PointsGenerator generator;
        for (int i = 0; i < tests_count; i++) {
            auto [x, y] = generator.generate_point();
            assert(x >= generator.x_min && x <= generator.x_max);
            assert(y >= generator.y_min && y <= generator.y_max);
        }
    }

    void init_new_groups(int groups_count = DEFAULT_GROUPS_COUNT) {
        if (groups_count != groups.size()) {
            index_distribution = std::uniform_int_distribution(0, groups_count - 1);
            groups.resize(groups_count);
        }
        for (auto& group : groups) {
            double x_base = x_distribution(x_gen);
            double x_delta = x_distribution(x_gen);
            double y_base = y_distribution(y_gen);
            double y_delta = y_distribution(y_gen);
            group.x_min = wrap_around(x_base - x_delta, x_min, x_max);
            group.x_max = wrap_around(x_base + x_delta, x_min, x_max);
            if (group.x_min > group.x_max) std::swap(group.x_min, group.x_max);
            group.y_min = wrap_around(y_base - y_delta, y_min, y_max);
            group.y_max = wrap_around(y_base + y_delta, y_min, y_max);
            if (group.y_min > group.y_max) std::swap(group.y_min, group.y_max);
        }
    }

    explicit PointsGenerator(int groups_count = DEFAULT_GROUPS_COUNT) : x_gen(rd()), y_gen(rd()),
        x_distribution(x_min, x_max), y_distribution(y_min, y_max) // These don't include the max value
    {
        init_new_groups(groups_count);
    }

    Point generate_point() {
        auto group_index = index_distribution(index_gen);
        auto& group = groups[group_index];
        const auto x = x_distribution(x_gen);
        const auto y = y_distribution(y_gen);
        return {
            wrap_around(x, group.x_min, group.x_max),
            wrap_around(y, group.y_min, group.y_max)
        };
    }
};

void generate_points_json_ofstream(const std::string& file_name, size_t points_count, int groups_count = DEFAULT_GROUPS_COUNT) {
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

void generate_points_json_string(const std::string& file_name, size_t points_count, int groups_count = DEFAULT_GROUPS_COUNT) {
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

int main(int argc, char** argv) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <output_file_name> <points_count>\n";
        return 1;
    }

    generate_points_json_ofstream(argv[1], std::stoull(argv[2]));
}