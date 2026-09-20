const std = @import("std");

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const input = try std.fs.File.stdin().readToEndAlloc(alloc, 1 << 30);
    var n: usize = 0;
    while (n < input.len and input[n] >= 'a' and input[n] <= 'z') : (n += 1) {}
    const s = input[0..n];

    const out = try alloc.alloc(u8, s.len * 21 + 2);
    var pos: usize = 0;
    var i: usize = 0;
    while (i < s.len) {
        var j = i;
        while (j < s.len and s[j] == s[i]) : (j += 1) {}
        const w = try std.fmt.bufPrint(out[pos..], "{c}{d}", .{ s[i], j - i });
        pos += w.len;
        i = j;
    }
    out[pos] = '\n';
    pos += 1;
    try std.fs.File.stdout().writeAll(out[0..pos]);
}
