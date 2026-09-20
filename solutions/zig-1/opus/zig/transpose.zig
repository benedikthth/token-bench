const std = @import("std");

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const input = try std.fs.File.stdin().readToEndAlloc(alloc, 1 << 30);
    var it = std.mem.tokenizeAny(u8, input, " \r\n\t");
    const r = try std.fmt.parseInt(usize, it.next() orelse return, 10);
    const c = try std.fmt.parseInt(usize, it.next().?, 10);
    const m = try alloc.alloc(i64, r * c);
    for (m) |*v| v.* = try std.fmt.parseInt(i64, it.next().?, 10);

    var out: std.ArrayList(u8) = .empty;
    var buf: [32]u8 = undefined;
    for (0..c) |j| {
        for (0..r) |i| {
            if (i > 0) try out.append(alloc, ' ');
            try out.appendSlice(alloc, try std.fmt.bufPrint(&buf, "{d}", .{m[i * c + j]}));
        }
        try out.append(alloc, '\n');
    }
    try std.fs.File.stdout().writeAll(out.items);
}
