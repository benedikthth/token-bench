const std = @import("std");

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const data = try std.fs.File.stdin().readToEndAlloc(alloc, 1 << 30);
    var out_buf: [65536]u8 = undefined;
    var w = std.fs.File.stdout().writer(&out_buf);
    const out = &w.interface;

    const vals = [_]u32{ 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1 };
    const syms = [_][]const u8{ "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I" };

    var it = std.mem.tokenizeAny(u8, data, " \t\r\n");
    while (it.next()) |tok| {
        var n = try std.fmt.parseInt(u32, tok, 10);
        for (vals, 0..) |v, i| {
            while (n >= v) {
                try out.writeAll(syms[i]);
                n -= v;
            }
        }
        try out.writeAll("\n");
    }
    try out.flush();
}
