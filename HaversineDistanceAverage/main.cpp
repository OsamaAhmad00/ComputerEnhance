#include <fstream>
#include <iostream>

#include "HaversineDistance.hpp"
#include "../HaversineDistanceInputJSONGenerator/GenerateJSON.hpp"
#include "../EstimateTSCFrequency/EstimateTSCFrequency.hpp"

#include "../Profiler/Profiler.hpp"
#include "../Profiler/Profiler.cpp"  // Quick hack instead of linking with anything else

double compute_average(const std::string& filename) {
    profile_scope("Total");

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

        {
            profile_scope("Read");
            if (!std::getline(input, line)) break;
        }

        double x0, y0, x1, y1;

        {
            profile_scope("Parse");
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
        }

        // std::cout << std::format("Line {}: x0 = {}, y0 = {}, x1 = {}, y1 = {}\n", line_num, x0, y0, x1, y1);

        {
            profile_scope("Compute");
            sum += haversine_distance(x0, y0, x1, y1, EarthRadius);
        }

        ++line_num;
    }

    if (state != Global) {
        std::cerr << "Input must end with ']'\n";
    }

    return sum / size;
}

void test_multiple_files(int runs = 100, int points_count = 1000000) {
    for (int i = 0; i < runs; ++i) {
        generate_points_json_ofstream("output.json", points_count);
        auto average = compute_average("output.json");
        std::cout << "Average = " << average << '\n';
    }
}

int main(int argc, char** argv) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <input file>\n";
        std::exit(1);
    }

    profiler_data.start_profiling();
    auto average = compute_average(argv[1]);
    profiler_data.end_profiling();

    std::cout << "Average = " << average << "\n\n";

    std::cout << profiler_data.report() << '\n';
}