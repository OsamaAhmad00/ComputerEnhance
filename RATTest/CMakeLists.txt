cmake_minimum_required(VERSION 3.31)
project(RATTest)

set(CMAKE_CXX_STANDARD 26)

enable_language(ASM)

add_executable(RATTest main.cpp Loops.s)
