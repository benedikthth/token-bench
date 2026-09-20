const std = @import("std");

const values = [_]u32{ 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1 };
const symbols = [_][]const u8{ "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I" };

pub fn main() !void {
    const stdin = std.fs.File.stdin().deprecatedReader();
    const stdout = std.fs.File.stdout().deprecatedWriter();

    var buf: [64]u8 = undefined;
    while (true) {
        const line = stdin.readUntilDelimiterOrEof(&buf, '\n') catch |err| {
            if (err == error.StreamTooLong) continue else return err;
        } orelse break;
        const trimmed = std.mem.trim(u8, line, " \t\r\n");
        if (trimmed.len == 0) continue;
        var n = try std.fmt.parseInt(u32, trimmed, 10);
        var i: usize = 0;
        while (n > 0) : (i += 1) {
            while (n >= values[i]) {
                try stdout.writeAll(symbols[i]);
                n -= values[i];
            }
        }
        try stdout.writeAll("\n");
    }
}
