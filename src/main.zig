const std = @import("std");

// Global constant
const global_const: u8 = 42; //8 bit unsigned integer

//Global variable
var global_var: u8 = 0;

// const some_var = 0; // type inference

pub fn main() !void {
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
