const std = @import("std");

const Entry = struct {
    word: []const u8,
    count: u64,
};

fn lessThan(_: void, a: Entry, b: Entry) bool {
    if (a.count != b.count) return a.count > b.count;
    return std.mem.lessThan(u8, a.word, b.word);
}

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const alloc = arena_state.allocator();

    const stdin = std.fs.File.stdin();
    const input = try stdin.readToEndAlloc(alloc, 1 << 30);

    // Lowercase in place.
    for (input) |*c| {
        if (c.* >= 'A' and c.* <= 'Z') c.* += 32;
    }

    var map = std.StringHashMap(u64).init(alloc);

    var i: usize = 0;
    while (i < input.len) {
        const c = input[i];
        if (c >= 'a' and c <= 'z') {
            const start = i;
            while (i < input.len and input[i] >= 'a' and input[i] <= 'z') : (i += 1) {}
            const gop = try map.getOrPut(input[start..i]);
            if (gop.found_existing) {
                gop.value_ptr.* += 1;
            } else {
                gop.value_ptr.* = 1;
            }
        } else {
            i += 1;
        }
    }

    var entries = try std.ArrayList(Entry).initCapacity(alloc, map.count());
    var it = map.iterator();
    while (it.next()) |kv| {
        entries.appendAssumeCapacity(.{ .word = kv.key_ptr.*, .count = kv.value_ptr.* });
    }

    std.mem.sort(Entry, entries.items, {}, lessThan);

    var buf: [1 << 16]u8 = undefined;
    var writer = std.fs.File.stdout().writer(&buf);
    const w = &writer.interface;
    for (entries.items) |e| {
        try w.print("{s} {d}\n", .{ e.word, e.count });
    }
    try w.flush();
}
