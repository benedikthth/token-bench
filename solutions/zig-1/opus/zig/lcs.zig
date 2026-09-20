const std = @import("std");

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const input = try std.fs.File.stdin().readToEndAlloc(alloc, 1 << 20);
    var it = std.mem.splitScalar(u8, input, '\n');
    const a = std.mem.trim(u8, it.next() orelse "", " \r\t");
    const b = std.mem.trim(u8, it.next() orelse "", " \r\t");

    const prev = try alloc.alloc(u32, b.len + 1);
    const cur = try alloc.alloc(u32, b.len + 1);
    @memset(prev, 0);
    @memset(cur, 0);
    var p = prev;
    var c = cur;
    for (a) |ca| {
        c[0] = 0;
        for (b, 0..) |cb, j| {
            if (ca == cb) {
                c[j + 1] = p[j] + 1;
            } else {
                c[j + 1] = @max(p[j + 1], c[j]);
            }
        }
        const t = p;
        p = c;
        c = t;
    }

    var buf: [32]u8 = undefined;
    const out = try std.fmt.bufPrint(&buf, "{d}\n", .{p[b.len]});
    try std.fs.File.stdout().writeAll(out);
}
