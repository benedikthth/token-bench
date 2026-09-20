const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdin = std.fs.File.stdin().deprecatedReader();
    const input = try stdin.readAllAlloc(allocator, 1 << 30);
    defer allocator.free(input);

    var it = std.mem.tokenizeAny(u8, input, " \t\r\n");

    const r = try std.fmt.parseInt(i64, it.next().?, 10);
    const c = try std.fmt.parseInt(i64, it.next().?, 10);

    const rows: usize = @intCast(r);
    const cols: usize = @intCast(c);

    const data = try allocator.alloc(i64, rows * cols);
    defer allocator.free(data);

    for (0..rows) |i| {
        for (0..cols) |j| {
            data[i * cols + j] = try std.fmt.parseInt(i64, it.next().?, 10);
        }
    }

    var out_buf: std.ArrayList(u8) = .empty;
    defer out_buf.deinit(allocator);
    const writer = out_buf.writer(allocator);

    for (0..cols) |j| {
        for (0..rows) |i| {
            if (i != 0) try writer.writeByte(' ');
            try writer.print("{d}", .{data[i * cols + j]});
        }
        try writer.writeByte('\n');
    }

    const stdout = std.fs.File.stdout().deprecatedWriter();
    try stdout.writeAll(out_buf.items);
}
