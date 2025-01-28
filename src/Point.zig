const std = @import("std");

x: f32,
y: f32 = 0,

const Point = @This();

// Namespaced function
fn new(x: f32, y: f32) Point {
    return Point{ .x = x, .y = y };
}

// Method
fn distance(self: Point, other: Point) f32 {
    const dx = self.x - other.x;
    const dy = self.y - other.y;
    return std.math.sqrt(std.math.pow(f32, dx, 2) + std.math.pow(f32, dy, 2));
}
