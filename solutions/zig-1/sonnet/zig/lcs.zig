const std = @import("std");

fn trimLine(s: []const u8) []const u8 {
    var end = s.len;
    while (end > 0 and (s[end - 1] == '\r' or s[end - 1] == '\n')) : (end -= 1) {}
    return s[0..end];
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdin = std.fs.File.stdin().deprecatedReader();
    const input = try stdin.readAllAlloc(allocator, 1 << 24);
    defer allocator.free(input);

    var lines = std.mem.splitScalar(u8, input, '\n');
    const line1_raw = lines.next() orelse "";
    const line2_raw = lines.next() orelse "";

    const a = trimLine(line1_raw);
    const b = trimLine(line2_raw);

    const n = a.len;
    const m = b.len;

    var prev = try allocator.alloc(u16, m + 1);
    defer allocator.free(prev);
    var cur = try allocator.alloc(u16, m + 1);
    defer allocator.free(cur);

    @memset(prev, 0);

    var i: usize = 0;
    while (i < n) : (i += 1) {
        cur[0] = 0;
        var j: usize = 0;
        while (j < m) : (j += 1) {
            if (a[i] == b[j]) {
                cur[j + 1] = prev[j] + 1;
            } else {
                cur[j + 1] = if (prev[j + 1] > cur[j]) prev[j + 1] else cur[j];
            }
        }
        const tmp = prev;
        prev = cur;
        cur = tmp;
    }

    const result = prev[m];

    const stdout = std.fs.File.stdout().deprecatedWriter();
    try stdout.print("{d}\n", .{result});
}
