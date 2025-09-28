cmake_minimum_required(VERSION 3.31)
project(BranchPredictionTest)

set(CMAKE_CXX_STANDARD 26)

enable_language(ASM)

add_compile_options(-stdlib=libc++)
add_link_options(-stdlib=libc++)

if(WIN32)
    add_executable(BranchPredictionTest main.cpp LoopsWindows.s)
else()
    add_executable(BranchPredictionTest main.cpp LoopsLinux.s)
endif()

