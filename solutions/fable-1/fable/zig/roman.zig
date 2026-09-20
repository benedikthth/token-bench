const std = @import("std");

const values = [_]u32{ 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1 };
const symbols = [_][]const u8{ "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I" };

pub fn main() !void {
    const gpa = std.heap.page_allocator;
    const stdin = std.fs.File.stdin();
    const stdout = std.fs.File.stdout();

    // Read all of stdin into a growable buffer using plain file reads.
    var input = std.ArrayList(u8).empty;
    defer input.deinit(gpa);
    var chunk: [65536]u8 = undefined;
    while (true) {
        const n = try stdin.read(&chunk);
        if (n == 0) break;
        try input.appendSlice(gpa, chunk[0..n]);
    }

    var output = std.ArrayList(u8).empty;
    defer output.deinit(gpa);

    var it = std.mem.splitScalar(u8, input.items, '\n');
    while (it.next()) |raw| {
        const line = std.mem.trim(u8, raw, " \t\r");
        if (line.len == 0) continue;
        var n = try std.fmt.parseInt(u32, line, 10);
        for (values, 0..) |v, i| {
            while (n >= v) : (n -= v) {
                try output.appendSlice(gpa, symbols[i]);
            }
        }
        try output.append(gpa, '\n');
    }

    var written: usize = 0;
    while (written < output.items.len) {
        written += try stdout.write(output.items[written..]);
    }
}
