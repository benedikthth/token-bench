const std = @import("std");

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const data = try std.fs.File.stdin().readToEndAlloc(alloc, 1 << 30);
    var out: std.ArrayList(u8) = .empty;
    var stack: std.ArrayList(u8) = .empty;

    var end = data.len;
    if (end > 0 and data[end - 1] == '\n') end -= 1;
    if (data.len == 0) return;

    var it = std.mem.splitScalar(u8, data[0..end], '\n');
    while (it.next()) |raw| {
        const line = std.mem.trimRight(u8, raw, "\r");
        stack.clearRetainingCapacity();
        var ok = true;
        for (line) |c| {
            switch (c) {
                '(', '[', '{' => try stack.append(alloc, c),
                ')', ']', '}' => {
                    const want: u8 = switch (c) {
                        ')' => '(',
                        ']' => '[',
                        else => '{',
                    };
                    if (stack.items.len == 0 or stack.pop().? != want) {
                        ok = false;
                        break;
                    }
                },
                else => {},
            }
        }
        if (stack.items.len != 0) ok = false;
        try out.appendSlice(alloc, if (ok) "yes\n" else "no\n");
    }
    try std.fs.File.stdout().writeAll(out.items);
}
