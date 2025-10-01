cmake_minimum_required(VERSION 3.31)
project(MovPortsEstimation)

set(CMAKE_CXX_STANDARD 26)

enable_language(ASM)

add_executable(MovPortsEstimation main.cpp Loops.s)
