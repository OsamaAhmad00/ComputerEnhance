#pragma once

constexpr double EarthRadius = 6372.8;

double haversine_distance(double x0, double y0, double x1, double y1, double radius = EarthRadius);
