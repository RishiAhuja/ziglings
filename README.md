# ZigLings: A Journey Through Zig Programming Concepts

## Table of Contents
1. [Names and Numbers](#names-and-numbers)
2. [Numeric Operations](#numeric-operations)
3. [Arrays](#arrays)
4. [Booleans and Optionals](#booleans-and-optionals)
5. [If Statements](#if-statements)
6. [Blocks and Switch](#blocks-and-switch)
7. [Enums and Unions](#enums-and-unions)

## Names and Numbers

In Zig, variables and constants have strong type safety with explicit type declarations:

```zig
// Global constant
const global_const: u8 = 42; // 8-bit unsigned integer

// Global variable
var global_var: u8 = 0;
```

### Integer Types
Zig provides precise integer types:
- `u1`: 1-bit unsigned integer
- `u8`: 8-bit unsigned integer
- `u16`: 16-bit unsigned integer
- `u32`: 32-bit unsigned integer

Example:
```zig
const zero: u1 = 0;
const two: u8 = 2;
const two_fifty: u8 = 250;
```

## Numeric Operations

Zig offers multiple ways to handle numeric overflow:

1. **Wrapping Multiplication** (`*%`):
```zig
result = two *% two_fifty; // Wraps around if overflow occurs
```

2. **Saturation Multiplication** (`*|`):
```zig
result = two *| two_fifty; // Saturates at max value
```

### Type Coercion
Zig allows safe type conversions:
```zig
const a: u8 = 42;
const b: u16 = a;      // Safe upcast
const c: u32 = b;      // Safe upcast

// Unsafe cast requires explicit conversion
const d: u16 = @intCast(c);
```

### Float to Integer Conversion
```zig
const a_float: f32 = 42.0;
const an_int: i32 = @intFromFloat(a_float);
```

## Arrays

Zig arrays are fixed-size and length must be known at compile-time:

```zig
// Array initialization
const a1: [5]u8 = [5]u8{ 1, 2, 3, 4, 5 };

// Array repetition
const a2 = a1 ** 2;           // Repeats array
const a3 = [_]u8{0} ** 5;     // Creates array of zeros

// Sentinel-terminated arrays
const a5: [2:0]u8 = .{ 1, 2 }; // Null-terminated array

// Array concatenation
const a6 = a1 ++ a1;
```

## Booleans and Optionals

### Optionals
In Zig, `?` denotes an optional type that can be `null`:

```zig
var some_optional: ?u8 = null;
some_optional = 42;

// Unwrapping optionals
const some_byte: u8 = some_optional.?;  // Panics if null
// const some_byte: u8 = some_optional orelse 1;  // Provides default

// Optional handling with payload capture
if (some_optional) |unwrapped| {
    std.debug.print("Value: {}\n", .{unwrapped});
} else {
    std.debug.print("No value\n", .{});
}
```

## If Statements

Zig's if statements can include optional unwrapping and type inference.

## Blocks and Switch

### Blocks (`blk`)
Blocks create scopes and can return values:

```zig
const result2 = blk: {
    const x1 = 20;
    const y1 = 20;
    break :blk x1 + y1;
};
```

### Switch Statements
Zig's switch is powerful with range matching and value capture:

```zig
switch (x) {
    0...20 => std.debug.print("0 to 20\n", .{}),
    31, 32, 33 => std.debug.print("31-33\n", .{}),
    40, 41, 42 => |n| std.debug.print("40-42: {}\n", .{n}),
    else => std.debug.print("Other\n", .{}),
}
```

## Enums and Unions

### Enums
```zig
const Color = enum(u2) {
    Red,
    Green,
    Blue,
    _, // Non-exhaustive enum
};

const color: Color = .Red;
const color_value = @intFromEnum(color);
```

### Unions
```zig
// Simple union
const Number = union {
    int: u32,
    float: f32,
};

// Tagged union
const Number2 = union(enum) {
    Int: u32,
    Float: f32,

    fn is(self: Number2, tag: std.meta.Tag(Number2)) bool {
        return self == tag;
    }
};
```

## Running the Code
To run this Zig code:
```bash
zig run main.zig
```

To run tests:
```bash
zig build test
```

## Contributing
Feel free to explore, learn, and contribute to ZigLings!
