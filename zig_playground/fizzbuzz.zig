const std = @import("std");

fn fb(num: u8) !?[]const u8 {
    const div3 = num % 3 == 0;
    const div5 = num % 5 == 0;
    if (div3) {
        return "Fizz\n";
    } else if (div5) {
        return "Buzz\n";
    } else if (div3 and div5) {
        return "FizzBuzz\n";
    } else {
        var buf: [256]u8 = undefined;
        const str = std.fmt.bufPrint(&buf, "{}", .{num});
        return str;
    }
}

pub fn main() !void {
    const stdout = std.fs.File.stdout();
    var count: u8 = 1;

    while (count < 100) : (count += 1) {
        if (fb(count)) |s| {
            try stdout.writeAll(s);
        }
    }
}
