const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const stdin_file = std.fs.File.stdin();
    const input = try stdin_file.readToEndAlloc(allocator, 1 << 30);
    defer allocator.free(input);

    var out: std.ArrayList(u8) = .empty;
    defer out.deinit(allocator);

    var stack: std.ArrayList(u8) = .empty;
    defer stack.deinit(allocator);

    if (input.len == 0) {
        return;
    }

    const trimmed = if (input[input.len - 1] == '\n') input[0 .. input.len - 1] else input;

    var lines = std.mem.splitScalar(u8, trimmed, '\n');
    while (lines.next()) |line_raw| {
        const line = std.mem.trimRight(u8, line_raw, "\r");
        stack.clearRetainingCapacity();
        var ok = true;
        for (line) |c| {
            switch (c) {
                '(', '[', '{' => try stack.append(allocator, c),
                ')' => {
                    if (stack.items.len == 0 or stack.pop().? != '(') ok = false;
                },
                ']' => {
                    if (stack.items.len == 0 or stack.pop().? != '[') ok = false;
                },
                '}' => {
                    if (stack.items.len == 0 or stack.pop().? != '{') ok = false;
                },
                else => {},
            }
        }
        if (stack.items.len != 0) ok = false;
        try out.appendSlice(allocator, if (ok) "yes\n" else "no\n");
    }

    try std.fs.File.stdout().writeAll(out.items);
}
