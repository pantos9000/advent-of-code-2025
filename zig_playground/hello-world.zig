const std = @import("std");
const expect = std.testing.expect;

pub fn main() void {

    // _ = std.fs.cwd().openFile("does_not_exist/foo.txt", .{});
}

test "foo" {
    const x: i32 = 5;
    try expect(x == 5);
}

test "if statement" {
    const a = true;
    var x: u32 = 0;
    x += if (a) 1 else 2;
    try expect(x == 1);
}

const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound,
    Foo,
    Bar,
};

const AllocationError = error{ Foo, Bar };

test "coerce error from a subset to a superset" {
    const err: FileOpenError = AllocationError.Foo;
    try expect(err == FileOpenError.Foo);
}

test "error union" {
    const maybe_error: AllocationError!u16 = 10;
    const no_error = maybe_error catch 0;

    try expect(@TypeOf(no_error) == u16);
    try expect(no_error == 10);
}

fn ok_func_with_error_type() AllocationError!u32 {
    return 42;
}

fn ok_func_without_error_type() !u32 {
    return 42;
}

test "ok funcs" {
    var ret: u32 = 0;
    ret = try ok_func_with_error_type();
    try expect(ret == 42);
    ret = try ok_func_without_error_type();
    try expect(ret == 42);
}

fn foo() AllocationError!u32 {
    return AllocationError.Foo;
}

fn failing_func_without_error_type(b: bool) !u32 {
    if (b) {
        return try foo();
    }
    return error.Something;
}

test "failing funcs" {
    var ret: u32 = 0;
    ret = switch (failing_func_without_error_type(false)) {
        error.Something => 1,
        error.Foo => 2,
        error.Bar => 3,
    };
    try expect(ret == 1);
}
