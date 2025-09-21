#include <fstream>
#include <iostream>

#include "HaversineDistance.hpp"
#include "../HaversineDistanceInputJSONGenerator/GenerateJSON.hpp"
#include "../EstimateTSCFrequency/EstimateTSCFrequency.hpp"

struct TicksCounter {
    inline static uint64_t tsc_freq = estimate_tsc_frequency(100);

    uint64_t sum = 0;
    uint64_t start = 0;

    void play() {
        start = read_tsc();
    }

    void pause() {
        sum += read_tsc() - start;
    }

    double ms() {
        return sum * 1000 / static_cast<double>(tsc_freq);
    }
};

struct Report {
    TicksCounter read_ticks;
    TicksCounter parse_ticks;
    TicksCounter compute_ticks;
    TicksCounter total_ticks;
};

std::pair<double, Report> compute_average(const std::string& filename) {
    Report report;

    report.total_ticks.play();

    enum {
        Global,
        InsideArray,
        InsideItem,
        InsideItemKey,
        BetweenItemKeyAndValue,
        InsideItemValue,
    } state = Global;

    size_t size = 0;
    double sum = 0;
    std::ifstream input(filename);
    std::string line;
    std::string key;
    std::string value;
    size_t line_num = 1;
    while (true) {

        report.read_ticks.play();
        if (!std::getline(input, line)) break;
        report.read_ticks.pause();

        report.parse_ticks.play();
        double x0, y0, x1, y1;
        bool x0_found = false;
        bool y0_found = false;
        bool x1_found = false;
        bool y1_found = false;
        for (char c : line) {
            if (std::iswspace(c)) continue;
            if (state == Global) {
                if (c != '[') {
                    std::cerr << "Input must start with '['\n";
                    std::exit(1);
                }
                state = InsideArray;
            } else if (state == InsideArray) {
                if (c == '{') {
                    ++size;
                    state = InsideItem;
                } else if (c == ',') {
                    // Nothing
                } else if (c == ']') {
                    state = Global;
                } else {
                    std::cerr << "Array items must start with '{'\n";
                    std::exit(1);
                }
            } else if (state == InsideItem) {
                if (c == ',') {
                    // Nothing
                } else if (c == '"') {
                    state = InsideItemKey;
                } else {
                    std::cerr << "Item keys must start with '\"'\n";
                    std::exit(1);
                }
            } else if (state == InsideItemKey) {
                if (c == '"') {
                    // Done with key
                    state = BetweenItemKeyAndValue;
                } else {
                    key += c;
                }
            } else if (state == BetweenItemKeyAndValue) {
                if (c == ':') {
                    state = InsideItemValue;
                } else {
                    std::cerr << "Keys and values must be separated by ':'\n";
                }
            } else if (state == InsideItemValue) {
                if (c == ',' || c == '}') {
                    auto d = std::stod(value);
                    if (key == "x0") {
                        x0 = d;
                        x0_found = true;
                    } else if (key == "y0") {
                        y0 = d;
                        y0_found = true;
                    } else if (key == "x1") {
                        x1 = d;
                        x1_found = true;
                    } else if (key == "y1") {
                        y1 = d;
                        y1_found = true;
                    } else {
                        std::cerr << "Unknown key: " << key << "\n";
                        std::exit(1);
                    }

                    key.clear();
                    value.clear();

                    // Done with value
                    if (c == '}') {
                        state = InsideArray;
                        if (!x0_found) {
                            std::cerr << "x0 not found in line " << line_num << "\n";
                            exit(1);
                        }

                        if (!y0_found) {
                            std::cerr << "y0 not found in line " << line_num << "\n";
                            exit(1);
                        }

                        if (!x1_found) {
                            std::cerr << "x1 not found in line " << line_num << "\n";
                            exit(1);
                        }

                        if (!y1_found) {
                            std::cerr << "y1 not found in line " << line_num << "\n";
                            exit(1);
                        }
                    } else {
                        // ','
                        state = InsideItem;
                    }
                } else {
                    value += c;
                }
            }
        }
        report.parse_ticks.pause();

        // std::cout << std::format("Line {}: x0 = {}, y0 = {}, x1 = {}, y1 = {}\n", line_num, x0, y0, x1, y1);

        report.compute_ticks.play();
        sum += haversine_distance(x0, y0, x1, y1, EarthRadius);
        report.compute_ticks.pause();

        ++line_num;
    }

    if (state != Global) {
        std::cerr << "Input must end with ']'\n";
    }

    report.total_ticks.pause();

    return { sum / size, report };
}

void test_multiple_files(int runs = 100, int points_count = 1000000) {
    for (int i = 0; i < runs; ++i) {
        generate_points_json_ofstream("output.json", points_count);
        auto average = compute_average("output.json");
        std::cout << "Average = " << average.first << '\n';
    }
}

int main(int argc, char** argv) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <input file>\n";
        std::exit(1);
    }

    auto[average, report] = compute_average(argv[1]);

    auto read = report.read_ticks.ms();
    auto parse = report.parse_ticks.ms();
    auto compute = report.compute_ticks.ms();
    auto total = report.total_ticks.ms();
    auto total_sum = read + parse + compute;

    std::cout << "Average = " << average << '\n';
    std::cout << "Read time = " << read << "ms (" << read / total_sum * 100 << "%)\n";
    std::cout << "Parse time = " << parse << "ms (" << parse / total_sum * 100 << "%)\n";
    std::cout << "Compute time = " << compute << "ms (" << compute / total_sum * 100 << "%)\n";
    std::cout << "Total time = " << total << "ms\n";
    std::cout << "Total time - Time sum = " << total - total_sum << "ms\n";
}