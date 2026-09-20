const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdin_file = std.fs.File.stdin();
    var in_buf: [64]u8 = undefined;
    const read_len = try stdin_file.readAll(&in_buf);

    const trimmed = std.mem.trim(u8, in_buf[0..read_len], " \t\r\n");
    const n: usize = if (trimmed.len == 0) 0 else try std.fmt.parseInt(usize, trimmed, 10);

    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(allocator);

    if (n >= 2) {
        const is_composite = try allocator.alloc(bool, n + 1);
        defer allocator.free(is_composite);
        @memset(is_composite, false);

        var i: usize = 2;
        while (i * i <= n) : (i += 1) {
            if (!is_composite[i]) {
                var j: usize = i * i;
                while (j <= n) : (j += i) {
                    is_composite[j] = true;
                }
            }
        }

        var first = true;
        var k: usize = 2;
        while (k <= n) : (k += 1) {
            if (!is_composite[k]) {
                if (!first) try out.append(allocator, ' ');
                first = false;
                var num_buf: [8]u8 = undefined;
                const s = try std.fmt.bufPrint(&num_buf, "{d}", .{k});
                try out.appendSlice(allocator, s);
            }
        }
    }
    try out.append(allocator, '\n');

    const stdout_file = std.fs.File.stdout();
    try stdout_file.writeAll(out.items);
}
