const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var in_buf: [64 * 1024]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&in_buf);
    const reader = &stdin_reader.interface;
    const input = try reader.allocRemaining(allocator, .unlimited);
    defer allocator.free(input);

    // Take only the first line, ignoring trailing newline/CR.
    var line: []const u8 = input;
    if (std.mem.indexOfScalar(u8, line, '\n')) |idx| {
        line = line[0..idx];
    }
    if (line.len > 0 and line[line.len - 1] == '\r') {
        line = line[0 .. line.len - 1];
    }

    var out_buf: [64 * 1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&out_buf);
    const out = &stdout_writer.interface;

    var i: usize = 0;
    while (i < line.len) {
        const c = line[i];
        var j = i + 1;
        while (j < line.len and line[j] == c) : (j += 1) {}
        try out.writeByte(c);
        try out.print("{d}", .{j - i});
        i = j;
    }
    try out.writeByte('\n');
    try out.flush();
}
