const std = @import("std");

pub fn main() !void {
    var in_buf: [4096]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&in_buf);
    const r = &stdin_reader.interface;

    var n: usize = 0;
    while (r.takeDelimiterExclusive('\n')) |line| {
        const t = std.mem.trim(u8, line, " \t\r\n");
        if (t.len == 0) continue;
        n = try std.fmt.parseInt(usize, t, 10);
        break;
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }

    var composite = [_]bool{false} ** 100001;
    var i: usize = 2;
    while (i * i <= n) : (i += 1) {
        if (!composite[i]) {
            var j = i * i;
            while (j <= n) : (j += i) composite[j] = true;
        }
    }

    var out_buf: [65536]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&out_buf);
    const w = &stdout_writer.interface;

    var first = true;
    var p: usize = 2;
    while (p <= n) : (p += 1) {
        if (!composite[p]) {
            if (!first) try w.writeByte(' ');
            first = false;
            try w.print("{d}", .{p});
        }
    }
    try w.writeByte('\n');
    try w.flush();
}
