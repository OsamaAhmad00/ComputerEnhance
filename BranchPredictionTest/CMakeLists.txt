cmake_minimum_required(VERSION 3.31)
project(BranchPredictionTest)

set(CMAKE_CXX_STANDARD 26)

enable_language(ASM)

add_executable(BranchPredictionTest main.cpp ConditionalNOP.s)
