#include <algorithm>
#include <iostream>
#include <cstdint>
#include <numeric>
#include <vector>
#include <thread>

#ifdef _WIN32
#include <intrin.h>
#else
#include <x86intrin.h>
#endif

#define mes(name, input) measure(#name, name, input)
#define mes2(name, input1, input2) measure(#name, name, input1, input2)

// Depending on the size of the vector, different functions will perform better or worse.
constexpr int TRIALS = 1000;
constexpr int SIZE = 1 << 20;

std::string double_to_str(double d) {
    // If vectorized instructions are disabled, the provided double-to-string conversion doesn't work
    std::string result;
    auto dec = (long long)d;
    auto frac = d - dec;
    result += std::to_string(dec);
    result += ".";
    for (int i = 0; i < 6; i++) {
        frac *= 10;
        result += std::to_string((int)frac);
        frac -= (int)frac;
    }
    return result;
}

uint64_t get_cycles() {
    return __rdtsc();
}

template <typename Func, typename... Input>
uint64_t measure(const std::string& name, Func&& f, Input&&... input) {
    decltype(f(input...)) val;
    uint64_t cycles = std::numeric_limits<uint64_t>::max();
    for (int i = 0; i < TRIALS; i++) {
        const uint64_t start = get_cycles();
        val = f(input...);
        const uint64_t end = get_cycles();
        cycles = std::min(cycles, end - start);
    }
    auto IPC = static_cast<double>(SIZE) / cycles;
    std::cout << "Sum: " << val << '\n';
    std::cout << name << " took " << cycles << " cycles for " << SIZE << " elements\n";
    std::cout << "IPC: " << double_to_str(IPC) << "\n";
    std::cout << "\n";
    return cycles;
}

int64_t sum(std::vector<int>& v) {
    int64_t sum = 0;
    for (int i = 0; i < v.size(); i++) {
        sum += v[i];
    }
    return sum;
}

int64_t sum_unroll_2(std::vector<int>& v) {
    int64_t sum = 0;
    for (int i = 0; i < v.size(); i+=2) {
        sum += v[i];
        sum += v[i + 1];
    }
    return sum;
}

int64_t sum_unroll_4(std::vector<int>& v) {
    int64_t sum = 0;
    for (int i = 0; i < v.size(); i+=4) {
        sum += v[i];
        sum += v[i + 1];
        sum += v[i + 2];
        sum += v[i + 3];
    }
    return sum;
}

int64_t sum_unroll_2_sep(std::vector<int>& v) {
    int64_t sum1 = 0;
    int64_t sum2 = 0;
    for (int i = 0; i < v.size(); i+=2) {
        sum1 += v[i];
        sum2 += v[i + 1];
    }
    return sum1 + sum2;
}

int64_t sum_unroll_4_sep(std::vector<int>& v) {
    int64_t sum1 = 0;
    int64_t sum2 = 0;
    int64_t sum3 = 0;
    int64_t sum4 = 0;
    for (int i = 0; i < v.size(); i+=4) {
        sum1 += v[i];
        sum2 += v[i + 1];
        sum3 += v[i + 2];
        sum4 += v[i + 3];
    }
    return sum1 + sum2 + sum3 + sum4;
}

int64_t sum_unroll_4_sep_while(int* ptr, size_t size) {
    size >>= 2;

    int64_t sum1 = 0;
    int64_t sum2 = 0;
    int64_t sum3 = 0;
    int64_t sum4 = 0;
    while (size--) {
        sum1 += ptr[0];
        sum2 += ptr[1];
        sum3 += ptr[2];
        sum4 += ptr[3];
        ptr += 4;
}

    return sum1 + sum2 + sum3 + sum4;
}

// int64_t sum_unroll_8_sep(std::vector<int>& v) {
//     int64_t sum1 = 0;
//     int64_t sum2 = 0;
//     int64_t sum3 = 0;
//     int64_t sum4 = 0;
//     int64_t sum5 = 0;
//     int64_t sum6 = 0;
//     int64_t sum7 = 0;
//     int64_t sum8 = 0;
//     for (int i = 0; i < v.size(); i+=4) {
//         sum1 += v[i];
//         sum2 += v[i + 1];
//         sum3 += v[i + 2];
//         sum4 += v[i + 3];
//         sum5 += v[i + 4];
//         sum6 += v[i + 5];
//         sum7 += v[i + 6];
//         sum8 += v[i + 7];
//     }
//     return sum1 + sum2 + sum3 + sum4 + sum5 + sum6 + sum7 + sum8;
// }

std::atomic<int64_t> sum_mt = 0;

int64_t sum_unroll_sep_while_mt(int* ptr, size_t size) {
    constexpr int THREADS = 8;
    size /= THREADS;

    sum_mt = 0;

    std::vector<std::jthread> threads;
    threads.reserve(THREADS);
    for (int i = 0; i < THREADS; ++i) {
        threads.emplace_back([=] {
            auto sum = sum_unroll_4_sep_while(ptr, size);
            sum_mt += sum;
        });
        ptr += size;
    }

    for (auto& t : threads) t.join();

    return sum_mt.operator int64_t();
}

int main() {
    std::vector<int> v(SIZE);
    std::ranges::generate(v, [] { return rand(); });
    const int64_t val = std::accumulate(v.begin(), v.end(), 0LL);
    std::cout << "Sum: " << val << "\n\n";

    mes(sum, v);
    mes(sum_unroll_2, v);
    mes(sum_unroll_4, v);
    mes(sum_unroll_2_sep, v);
    mes(sum_unroll_4_sep, v);
    mes2(sum_unroll_4_sep_while, v.data(), v.size());
    mes2(sum_unroll_sep_while_mt, v.data(), v.size());
}
