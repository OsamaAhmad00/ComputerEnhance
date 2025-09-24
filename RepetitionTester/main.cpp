#define _CRT_SECURE_NO_WARNINGS

#include <vector>

#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <sys/stat.h>

typedef uint8_t u8;
typedef uint32_t u32;
typedef uint64_t u64;

typedef int32_t b32;

typedef float f32;
typedef double f64;

#define ArrayCount(Array) (sizeof(Array)/sizeof((Array)[0]))

#include "TestingFunctions.hpp"

struct test_function
{
    char const *Name;
    read_overhead_test_func *Func;
};
test_function TestFunctions[] =
{
    {"fread", ReadViaFRead},
    {"_read", ReadViaRead},
    {"ReadFile", ReadViaReadFile},
};

int main(int ArgCount, char **Args)
{
    // NOTE(casey): Since we do not use these functions in this particular build, we reference their pointers
    // here to prevent the compiler from complaining about "unused functions".
    (void)&IsInBounds;
    (void)&AreEqual;

    u64 CPUTimerFreq = estimate_tsc_frequency(100);

    if(ArgCount == 2)
    {
        char *FileName = Args[1];
#if _WIN32
        struct __stat64 Stat;
        _stat64(FileName, &Stat);
#else
        struct stat Stat;
        stat(FileName, &Stat);
#endif

        read_parameters Params = {};
        Params.FileName = FileName;

        const auto n = std::size(TestFunctions);
        std::vector<RepetitionTester> testers;
        testers.reserve(n);
        for(u32 FuncIndex = 0; FuncIndex < n; ++FuncIndex) {
            testers.emplace_back(TestFunctions[FuncIndex].Name, CPUTimerFreq, Stat.st_size);
        }

        // if(Params.Dest.Count > 0)
        // {
            for(;;)
            {
                // With this setup, where we always allocate before
                // the tests, you'll find that the first function almost
                // always gets the slowest iteration as iteration 0. This
                // is because the first access to the memory causes page
                // faults, which causes it to slow down a lot
                Params.Dest = AllocateBuffer(Stat.st_size);
                for(u32 FuncIndex = 0; FuncIndex < n; ++FuncIndex)
                {
                    test_function TestFunc = TestFunctions[FuncIndex];
                    auto& tester = testers[FuncIndex];
                    TestFunc.Func(&tester, &Params);
                    std::cout << tester.report() << '\n';
                    // tester.reset_timer();
                    tester.reset();
                }
                FreeBuffer(&Params.Dest);
            }

            // NOTE(casey): We would normally call this here, but we can't because the compiler will complain about "unreachable code".
            // So instead we just reference the pointer to prevent the compiler complaining about unused function :(
            (void)&FreeBuffer;
        // }
        // else
        // {
        //     fprintf(stderr, "ERROR: Test data size must be non-zero\n");
        // }
    }
    else
    {
        fprintf(stderr, "Usage: %s [existing filename]\n", Args[0]);
    }

    return 0;
}