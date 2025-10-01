#pragma once

#include <format>
#include <limits>

#include "../EstimateTSCFrequency/EstimateTSCFrequency.hpp"

template <typename T>
auto min_val = std::numeric_limits<T>::min();

template <typename T>
auto max_val = std::numeric_limits<T>::max();

struct RepetitionTestingResult {
    struct Extreme {
        double value;
        uint64_t iter_num;
    };

    Extreme min = { max_val<double>, 0 };
    Extreme max = { min_val<double>, 0 };
    double total_time;
    uint64_t total_iterations;
    uint64_t bytes_per_iteration;
};

class RepetitionTester {

    static constexpr auto NOT_TESTING = 0;
    static constexpr auto MAX_PERIOD_WITH_NO_NEW_MAX_IN_SEC = 2;
    static constexpr auto NEW_MAX_DIFF_GRANULARITY = 0.01;

    double secs_since_last_max = 0;

    RepetitionTestingResult result { };

    std::string name;
    uint64_t cpu_freq;
    uint64_t start_ticks = NOT_TESTING;
    uint64_t processing_bytes = 0;
    uint64_t& current_iter = result.total_iterations;  // Just an alias
    bool done = false;

public:

    explicit RepetitionTester(std::string name, uint64_t cpu_freq, uint64_t processing_bytes = 0)
        : name(std::move(name)), cpu_freq(cpu_freq), processing_bytes(processing_bytes) {
        result.bytes_per_iteration = processing_bytes;
    }

    void start_iter() {
        if (done) error("The repetition testing has ended");
        if (start_ticks != NOT_TESTING) error("A test is already in process");

        start_ticks = read_tsc();
    }

    void end_iter() {
        auto end_ticks = read_tsc();
        if (start_ticks == NOT_TESTING) {
            error("No test is in process\n");
        }

        auto ticks = end_ticks - start_ticks;
        auto time = static_cast<double>(ticks) / cpu_freq;
        auto throughput = processing_bytes / time;

        secs_since_last_max += time;

        if (result.min.value > throughput) {
            result.min.value = throughput;
            result.min.iter_num = current_iter;
        }

        if ((throughput - result.max.value) >= NEW_MAX_DIFF_GRANULARITY) {
            result.max.value = throughput;
            result.max.iter_num = current_iter;

            // Reset timer
            secs_since_last_max = 0;
        }

        if (secs_since_last_max > MAX_PERIOD_WITH_NO_NEW_MAX_IN_SEC) {
            done = true;
        }

        result.total_time += time;

        ++current_iter;

        start_ticks = NOT_TESTING;
    }

    void set_or_assert_bytes_count(const uint64_t bytes) {
        // This can be before or after starting the test, but
        // you can't change the number of bytes, since this is
        // a repeated test, and the parameters should remain the
        // same, without a change in any iteration
        if (bytes != processing_bytes && processing_bytes != 0) {
            error(
                std::format("The bytes is set to {}, and you're trying to set it to {}", processing_bytes, bytes)
            );
        }
        processing_bytes = bytes;
    }

    void reset_timer() {
        secs_since_last_max = 0;
        done = false;
    }

    void reset(std::string new_name = "", uint64_t new_cpu_freq = 0) {
        result = { };
        result.bytes_per_iteration = processing_bytes;
        if (!new_name.empty()) name = std::move(new_name);
        if (new_cpu_freq) cpu_freq = new_cpu_freq;
        start_ticks = NOT_TESTING;
        reset_timer();
    }

    static void error(const std::string& message) {
        std::cerr << message << '\n';
        exit(1);
    }

    [[nodiscard]] bool is_done() const { return done; }

    [[nodiscard]] RepetitionTestingResult get_result() const { return result; }

    [[nodiscard]] std::string report() const {
        if (result.total_iterations == 0) error("No tests has run");

        auto total_bytes = result.bytes_per_iteration * result.total_iterations;
        auto average_throughput =  total_bytes / result.total_time;
        std::string report_str = name + '\n';
        report_str += std::string(20, '-') + '\n';
        report_str += std::format("Min throughput =\t {:.3f} GB/s\t on iteration {}\n", GB(result.min.value), result.min.iter_num);
        report_str += std::format("Max throughput =\t {:.3f} GB/s\t on iteration {}\n", GB(result.max.value), result.max.iter_num);
        report_str += std::format("Average throughput =\t {:.3f} GB/s\n", GB(average_throughput));
        report_str += std::format("Data per iteration =\t {:.3f} MB\n", MB(result.bytes_per_iteration));
        report_str += std::format("Total data =\t\t {:.3f} GBs\n", GB(total_bytes));
        report_str += std::format("Total time =\t\t {:.3f} seconds\n", result.total_time);
        report_str += std::format("Total iterations =\t {}\n", result.total_iterations);
        return report_str;
    }

private:

    static double MB(double bytes) { return bytes / (1ULL << 20); }

    static double GB(double bytes) { return bytes / (1ULL << 30); }
};