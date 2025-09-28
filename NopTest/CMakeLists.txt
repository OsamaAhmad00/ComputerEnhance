cmake_minimum_required(VERSION 3.31)
project(NopTest)

set(CMAKE_CXX_STANDARD 26)

enable_language(ASM)

add_executable(NopTest main.cpp Loops.s)
