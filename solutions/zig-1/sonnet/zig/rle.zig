const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const stdin = std.fs.File.stdin();
    const input = try stdin.readToEndAlloc(allocator, 1 << 20);
    defer allocator.free(input);

    var end = input.len;
    while (end > 0 and (input[end - 1] == '\n' or input[end - 1] == '\r')) {
        end -= 1;
    }
    const line = input[0..end];

    var buf: std.ArrayList(u8) = .empty;
    defer buf.deinit(allocator);

    var i: usize = 0;
    while (i < line.len) {
        const c = line[i];
        var count: usize = 1;
        while (i + count < line.len and line[i + count] == c) {
            count += 1;
        }
        try buf.print(allocator, "{c}{d}", .{ c, count });
        i += count;
    }
    try buf.append(allocator, '\n');

    const stdout = std.fs.File.stdout();
    try stdout.writeAll(buf.items);
}
