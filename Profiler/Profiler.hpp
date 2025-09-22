#pragma once

#include <algorithm>
#include <cstdint>
#include <array>
#include <cassert>
#include <format>
#include <string>
#include <ranges>

#include "../EstimateTSCFrequency/EstimateTSCFrequency.hpp"

using ProfilerAnchorID = uint64_t;

constexpr auto MAX_PROFILER_ANCHORS = 1 << 12;

struct ProfilerAnchor {
    const char* name;
    uint64_t inclusive_time;  // Time spent inside this block and all its children
    uint64_t exclusive_time;  // Time spent inside this block alone
    uint64_t used_count;      // The number of times it was used
    uint64_t bytes_processed; // The number of bytes processed by this block

    [[nodiscard]] std::string report_timing(double global_time, double frequency) const {
        auto inclusive_percentage = (inclusive_time * 100 ) / global_time;
        auto exclusive_percentage = (exclusive_time * 100 ) / global_time;
        auto inclusive_time_ms    = (inclusive_time * 1000) / frequency;
        auto exclusive_time_ms    = (exclusive_time * 1000) / frequency;
        return std::format(
            "{}\t: inclusive={}, {:.3f}ms ({:.3f}%),\texclusive={}, {:.3f}ms ({:.3f}%),\tuse_count={}\n",
            name,
            inclusive_time, inclusive_time_ms, inclusive_percentage,
            exclusive_time, exclusive_time_ms, exclusive_percentage,
            used_count
        );
    }

    [[nodiscard]] std::string report_throughput(double frequency) const {
        auto inclusive_time_sec = inclusive_time / frequency;
        auto megabytes = bytes_processed / double(1024 * 1024);
        auto throughput = bytes_processed / (inclusive_time_sec * 1024 * 1024 * 1024);
        return std::format(
            "{}\t: processed {:.3f} MB at rate {:.3f} GB/s,\tuse_count={}\n",
            name,
            megabytes,
            throughput,
            used_count
        );
    }
};

// We don't want any dynamic allocations, so we use a static array.
struct ProfilerData : public std::array<ProfilerAnchor, MAX_PROFILER_ANCHORS> {
    // Used to compute percentages
    uint64_t global_start_time;
    uint64_t global_end_time;

    ProfilerAnchorID max_anchor_id = 0;

    void start_profiling() {
        global_start_time = read_tsc();
    }

    void end_profiling() {
        global_end_time = read_tsc();
    }

    [[nodiscard]] std::string report_timing() const {
        const auto global_time = static_cast<double>(global_end_time - global_start_time);
        const auto frequency = static_cast<double>(estimate_tsc_frequency(100));
        std::string result = std::format("Total={}, {:.3f}ms\n\n", global_time, (global_time * 1000) / frequency);
        for (ProfilerAnchorID i = 1; i <= max_anchor_id; ++i) {
            result += (*this)[i].report_timing(global_time, frequency);
        }
        return result;
    }

    [[nodiscard]] std::string report_throughput() const {
        const auto global_time = static_cast<double>(global_end_time - global_start_time);
        const auto frequency = static_cast<double>(estimate_tsc_frequency(100));

        auto bytes = std::views::counted(data() + 1, max_anchor_id - 1) |
            std::views::transform(&ProfilerAnchor::bytes_processed);
        auto total_bytes_processed = std::ranges::fold_left(bytes, 0ULL, std::plus());

        std::string result = std::format("Total Processed Data = {} MB\n\n", total_bytes_processed);

        for (ProfilerAnchorID i = 1; i <= max_anchor_id; ++i) {
            result += (*this)[i].report_throughput(frequency);
        }

        return result;
    }
};

// Index 0 is reserved for the root anchor, which doesn't represent
// any block. This is to have simpler logic for the topmost block.
extern ProfilerAnchorID top_profiler_anchor_id;
extern ProfilerData profiler_data;

#ifdef PROFILE

struct ProfileScope {
    uint64_t start_time;
    uint64_t old_inclusive_time;
    ProfilerAnchorID id;
    ProfilerAnchorID parent_id;
    uint64_t bytes_processed;

    explicit ProfileScope(const char* name, const ProfilerAnchorID id, uint64_t bytes_processed = 0)
        : start_time(read_tsc()), old_inclusive_time(profiler_data[id].inclusive_time),
          id(id), parent_id(top_profiler_anchor_id), bytes_processed(bytes_processed)
    {
        assert(id < MAX_PROFILER_ANCHORS && "Profiler anchor ID is out of range. You've used too many scope profilers");
        profiler_data[id].name = name;
        top_profiler_anchor_id = id;
        profiler_data.max_anchor_id = std::max(profiler_data.max_anchor_id, id);
    }

    ~ProfileScope() {
        auto& parent = profiler_data[parent_id];
        auto& anchor = profiler_data[id];

        const auto end_time = read_tsc();
        const auto time_delta = end_time - start_time;

        parent.exclusive_time -= time_delta;

        anchor.exclusive_time += time_delta;
        anchor.inclusive_time = old_inclusive_time + time_delta;  // Overwrite children's writings
        anchor.used_count++;

        anchor.bytes_processed += bytes_processed;

        top_profiler_anchor_id = parent_id;
    }
};

// The 0th location is reserved for the root anchor.
#define profile_scope_with_throughput(name, size) ProfileScope __profile_scope_instance_##__LINE__(name, __COUNTER__ + 1, size)
#define profile_scope(name) profile_scope_with_throughput(name, 0)

#else

#define profile_scope(...)

#endif