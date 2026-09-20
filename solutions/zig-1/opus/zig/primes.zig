const std = @import("std");

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const input = try std.fs.File.stdin().readToEndAlloc(alloc, 1 << 20);
    const trimmed = std.mem.trim(u8, input, " \t\r\n");
    const n: usize = if (trimmed.len == 0) 0 else try std.fmt.parseInt(usize, trimmed, 10);

    const sieve = try alloc.alloc(bool, n + 1);
    @memset(sieve, true);
    var out = try alloc.alloc(u8, 8 * (n + 1) + 16);
    var len: usize = 0;
    var i: usize = 2;
    while (i <= n) : (i += 1) {
        if (!sieve[i]) continue;
        var j = i * i;
        while (j <= n) : (j += i) sieve[j] = false;
        if (len > 0) {
            out[len] = ' ';
            len += 1;
        }
        const s = try std.fmt.bufPrint(out[len..], "{d}", .{i});
        len += s.len;
    }
    out[len] = '\n';
    len += 1;
    try std.fs.File.stdout().writeAll(out[0..len]);
}
