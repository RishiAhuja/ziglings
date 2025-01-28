const std = @import("std");

// Global constant
const global_const: u8 = 42; //8 bit unsigned integer

//Global variable
var global_var: u8 = 0;

// const some_var = 0; // type inference

const Color = enum(u2) {
    Red,
    Green,
    Blue,
    _, // Non exhaustive enum
};
// You can also have members within enums

const Number = union {
    int: u32,
    float: f32,
};

// A union is a type that can hold one of several specified types,
// but only one at a time. It is useful when you want a variable
// to be able to store different types of values at different times.

// In Zig, a tagged union is a type that can hold one of several specified types,
// along with a tag that indicates which type is currently held.
// This is useful for creating types that can represent multiple different
// kinds of data while keeping track of which kind is currently in use.
const Number2 = union(enum) {
    Int: u32,
    Float: f32,

    fn is(self: Number2, tag: std.meta.Tag(Number2)) bool {
        return self == tag;
    }
};

fn foo(a: u8, b: u8) u8 {
    return a +| b;
}

// Zig determines whether to pass by value or by pointer based on the size of the type.

// Errors are like enums but with special treatment

// Error sets

const InputError = error{ InvalidInput, EmptyString };
const OSError = error{ FileNotFound, PermissionDenied, OutOfMemory };

// Error unions

const ParseError = InputError || OSError;

// Error sets can be used to group related errors together, while error unions can be used to represent multiple possible errors that can occur in a function.

// fn parseNumber(s: []const u8) ParseError!u8 {
//     if (s.len == 0) return error.EmptyString;
//     return std.fmt.parseInt(u8, s, 10);
// } // Function can either return a u8 or an error

const Point = struct {
    x: f32,
    y: f32 = 0,

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
};

// @fieldParentPtr is a built-in function in Zig
// that allows you to get a pointer to the parent
// struct from a pointer to one of its fields.

// fn setYBasedOnX(x: *f32, y: f32) void {
//     const point = @as(*Point, @fieldParentPtr(Point, x, .x));
//     point.y = y;
// The @as operator tells Zig explicitly what type to expect from @fieldParentPtr.
// This helps the compiler with type inference and makes the code more explicit.
// }

pub fn main() !void {
    const a_point: Point = .{ .x = 1.0, .y = 2.0 };
    std.debug.print("a_point: {any}\n", .{a_point});
    const b_point = Point.new(3.0, 4.0);
    std.debug.print("b_point: {any}\n", .{b_point});

    // Using method syntax

    // When you use method syntax (a_point.distance(b_point)), Zig automatically:
    // Uses a_point as the self parameter
    // Takes b_point as the other parameter

    const distance = a_point.distance(b_point);

    // Using namespaced function
    const distance2 = Point.distance(a_point, b_point);
    std.debug.print("distance: {}\n", .{distance});
    std.debug.print("distance2: {}\n", .{distance2});

    // Method Syntax: a_point.distance(b_point)

    // Uses dot notation
    // First argument (self) is implicit
    // More object-oriented style
    // Often used for instance methods
    // Namespaced Function: Point.distance(a_point, b_point)

    // Uses namespace notation
    // All arguments are explicit
    // More functional style
    // Often used for static/utility functions

    // comptime var some_var = 2;

    // const some_var: u8 = 2;
    // var some_var2 = undefined;
    // _ = some_var2;

    // std.debug.print("{}\n", .{some_var});
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    // std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.

    const zero: u1 = 0;
    const one: u1 = 1;
    const two: u8 = 2;
    const two_fifty: u8 = 250;

    var result = zero + one + two + two_fifty;
    std.debug.print("Result: {}\n", .{result});

    // result = two * two_fifty; // Overflow
    result = two *% two_fifty; // Wrapping
    std.debug.print("Result: {}\n", .{result});

    result = two *| two_fifty; // Saturation
    std.debug.print("Result: {}\n", .{result});

    // Type coerce when it's safe
    const a: u8 = 42;
    const b: u16 = a;
    const c: u32 = b;

    std.debug.print("a: {}, b: {}, c: {}\n", .{ a, b, c });

    // Type coerce when it's unsafe

    const d: u16 = @intCast(c);
    std.debug.print("d: {}\n", .{d});

    const a_float: f32 = 42.0;
    const an_int: i32 = @intFromFloat(a_float);
    std.debug.print("a_float: {}\n", .{a_float});
    std.debug.print("an_int: {}\n", .{an_int});

    // Arrays

    const a1: [5]u8 = [5]u8{ 1, 2, 3, 4, 5 };
    std.debug.print("a1: {any}, a1.len {}\n", .{ a1, a1.len });

    const a2 = a1 ** 2;
    std.debug.print("a2: {any}, a2.len {}\n", .{ a2, a2.len });

    const a3 = [_]u8{0} ** 5;
    std.debug.print("a3: {any}, a3.len {}\n", .{ a3, a3.len });

    // Array Lenght has to be comptime known

    // var x: u8 = 3;

    // const a4 = [x]u8{0} ** x;

    // var x: u8 = 3;
    const x: u8 = 3;

    const a4: [x]u8 = [_]u8{0} ** x;

    std.debug.print("a4: {any}, a4.len {}\n", .{ a4, a4.len });
    std.debug.print("x: {}\n", .{x});

    // Sential terminated values

    const a5: [2:0]u8 = .{ 1, 2 };
    std.debug.print("a5: {any}, a5.len = {}\n", .{ a5, a5.len });
    std.debug.print("a5[a5.len] = {} \n", .{a5[a5.len]});

    // Concatenation of two arrays

    const a6 = a1 ++ a1;
    std.debug.print("a6: {any}, a6.len = {}\n", .{ a6, a6.len });

    // Optionals in zig
    var some_optional: ?u8 = null; // only optionals can be null
    std.debug.print("some_optional = {?} \n", .{some_optional});
    some_optional = 42;
    std.debug.print("some_optional = {?} \n", .{some_optional});

    const some_byte: u8 = some_optional.?;
    // const some_byte: u8 = some_optional orelse 1; // default value
    // Asserting that some_optional is not null\
    // will panic if null
    std.debug.print("some_byte = {} \n", .{some_byte});

    if (some_optional) |unwrapped| {
        std.debug.print("some_optional unwrapped = {} \n", .{unwrapped});
        std.debug.print("some_optional unwrapped = {?} \n", .{some_optional});
        //
        // The payload receiver (|unwrapped|) in Zig is used to safely unwrap an optional value within an if statement.
        // This allows you to access the value inside the optional if it is not null, without having to manually check and unwrap it.
    } else {
        std.debug.print("else\n", .{});
    }

    // `blk` or blocks are used to create a scope for variables and defer statements.
    // They are useful for limiting the scope of variables and for creating complex expressions.

    const result2 = blk: {
        const x1 = 20;
        const y1 = 20;
        break :blk x1 + y1;
    };

    switch (x) {
        // Ranges inclusive of both ends
        0...20 => std.debug.print("Its from 0 to 20 {}\n", .{x}),
        31, 32, 33 => std.debug.print("Its 31, 32 or 33 {}\n", .{x}),
        // You can capture the matched value
        40, 41, 42 => |n| std.debug.print("Its 40, 41 or 42 {}\n", .{n}),

        77 => {
            // Can execute blocks of code
            std.debug.print("Its 77 {}\n", .{x});
        },
        else => std.debug.print("Its something else {}\n", .{x}),
    }

    std.debug.print("Result: {}\n", .{result2});

    // When the type can be inffered, you can omit the enum name
    // const color: Color = Color.Red;
    const color: Color = .Red;
    std.debug.print("Color: {}\n", .{color});
    std.debug.print("Color: {}\n", .{@intFromEnum(color)});

    // Using unions
    const number: Number = .{ .int = 13 };
    std.debug.print("Number: {}\n", .{number.int});

    // Pointers
    const a7: u8 = 42;
    const a7_ptr = &a7;

    std.debug.print("a7_ptr: {*}, @TypeOf: {}\n", .{ a7_ptr, @TypeOf(a7_ptr) });
    // Output: a7_ptr: u8@1003e13, @TypeOf: *const u8

    // Dereferencing
    var a8: u8 = 10;
    const a8_ptr = &a8;
    a8_ptr.* += 1;

    // Multi Item pointer
    var some_arr = [_]u8{ 1, 2, 3, 4, 5 };
    const d_ptr: [*]u8 = &some_arr;
    std.debug.print("d_ptr: {*}, @TypeOf: {}\n", .{ d_ptr, @TypeOf(d_ptr) });
    // Output: d_ptr: u8@7ffed7e44948, @TypeOf: [*]u8
    std.debug.print("@intFromPtr: {}\n", .{@intFromPtr(d_ptr)});

    // Slices
    var array2 = [_]u8{ 1, 2, 3, 4, 5 }; // Comptime known
    const array2_ptr = array2[0..array2.len];
    std.debug.print("array2_ptr: {*}, @TypeOf(array2_ptr): {} \n", .{ array2_ptr, @TypeOf(array2_ptr) });
    // Even though array2_ptr is a slice, it is still a pointer,  *[5]u8

    // We can overcome this by using a runtime known value

    // Slicing sytax
    var a_slice: []u8 = &some_arr;
    std.debug.print("a_slice: {*}, @TypeOf(a_slice): {} \n", .{ a_slice, @TypeOf(a_slice) });
    // Output: a_slice: u8@7ffea330116b, @TypeOf(a_slice): []u8
    // Slice is basically a multi-item pointer with a length and ptr field
    a_slice.ptr += 1;

    // For Loops

    // Element based for loop
    const a9 = [_]u8{ 1, 2, 3, 4, 5 };
    for (a9) |item| std.debug.print("item: {}\n", .{item});
    std.debug.print("\n", .{});

    // For loops with slices
    for (a9[0..]) |item| std.debug.print("item: {}\n", .{item});
    std.debug.print("\n", .{});
    // 0.. (unbounded) is the same as 0..a9.len

    // Index based for loops
    for (a9[0..], 0..a9.len) |item, i| {
        std.debug.print("item: {}, i: {}\n", .{ item, i });
    }
    std.debug.print("\n", .{});

    // You can Iterate over multiple objects, but they must of equal length
    for (a9[0..1], a9[1..2], a9[2..3]) |a12, b1, c1| {
        std.debug.print("a: {}, b: {}, c: {}\n", .{ a12, b1, c1 });
    }

    // for (a9[0..]) |*item| {
    //     item.* = item.* * 2;
    //     std.debug.print("item: {}\n", .{item});
    // }

    var i: u8 = 0;
    while (i < array2.len) : (i += 1) {
        std.debug.print("item: {}\n", .{array2[i]});
    }

    // const input = "212";

    // const result3 = parseNumber(input[0..]);

    // std.debug.print("@TypeOf: {any}\n", .{@TypeOf(result3)});
    // std.debug.print("Result3: {any}\n", .{result3});

    const hello = "Hello, World!"; // POinter to a Sentinal Terminated Array
    std.debug.print("Hello: {s}\n", .{hello});

    // Multiline Strings

    const multiline =
        \\ This is a multiline comment,  
        \\ And Escape characters are not interpreted \n
        \\ Here, They are printed literally
    ;

    std.debug.print("multiline: {s}\n", .{multiline});

    const c_point = Point{ .x = 1.0, .y = 2.0 };
    const c_point_ptr = &c_point;

    std.debug.print("c_point_ptr.y: {}, c_point_ptr.*y: {} \n", .{ c_point_ptr.y, c_point_ptr.*.y });

    // c_point_ptr.y, c_point_ptr.*.y are equivalent, we can access the field of a pointer to a struct directly without dereferencing it

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
