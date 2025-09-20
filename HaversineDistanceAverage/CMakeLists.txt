cmake_minimum_required(VERSION 3.31)
project(HaversineDistanceAverage)

set(CMAKE_CXX_STANDARD 26)

add_executable(HaversineDistanceAverage
    main.cpp
    HaversineDistance.cpp
)
