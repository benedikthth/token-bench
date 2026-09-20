const std = @import("std");

fn readAll(buf: []u8) usize {
    var total: usize = 0;
    while (total < buf.len) {
        const n = std.posix.read(0, buf[total..]) catch break;
        if (n == 0) break;
        total += n;
    }
    return total;
}

fn writeAll(data: []const u8) void {
    var off: usize = 0;
    while (off < data.len) {
        const n = std.posix.write(1, data[off..]) catch return;
        if (n == 0) return;
        off += n;
    }
}

fn trimLine(line: []const u8) []const u8 {
    var end = line.len;
    while (end > 0 and (line[end - 1] == '\r' or line[end - 1] == '\n')) end -= 1;
    return line[0..end];
}

pub fn main() void {
    var inbuf: [1 << 16]u8 = undefined;
    const len = readAll(&inbuf);
    const input = inbuf[0..len];

    var a: []const u8 = "";
    var b: []const u8 = "";
    var pos: usize = 0;
    var idx: usize = 0;
    while (idx < 2 and pos <= input.len) : (idx += 1) {
        var end = pos;
        while (end < input.len and input[end] != '\n') end += 1;
        const line = trimLine(input[pos..end]);
        if (idx == 0) a = line else b = line;
        pos = end + 1;
    }

    // Two-row DP.
    var prev: [2048]u32 = undefined;
    var cur: [2048]u32 = undefined;
    const m = b.len;
    @memset(prev[0 .. m + 1], 0);
    for (a) |ca| {
        cur[0] = 0;
        var j: usize = 1;
        while (j <= m) : (j += 1) {
            if (ca == b[j - 1]) {
                cur[j] = prev[j - 1] + 1;
            } else {
                cur[j] = if (prev[j] > cur[j - 1]) prev[j] else cur[j - 1];
            }
        }
        @memcpy(prev[0 .. m + 1], cur[0 .. m + 1]);
    }

    var outbuf: [32]u8 = undefined;
    const s = std.fmt.bufPrint(&outbuf, "{d}\n", .{prev[m]}) catch return;
    writeAll(s);
}
