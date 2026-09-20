const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input = try std.fs.File.stdin().readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(input);

    var counts = std.StringHashMap(u64).init(allocator);
    defer {
        var it = counts.keyIterator();
        while (it.next()) |k| allocator.free(k.*);
        counts.deinit();
    }

    var i: usize = 0;
    while (i < input.len) {
        if (std.ascii.isAlphabetic(input[i])) {
            const start = i;
            while (i < input.len and std.ascii.isAlphabetic(input[i])) : (i += 1) {}
            const word = input[start..i];

            const lower = try allocator.alloc(u8, word.len);
            defer allocator.free(lower);
            for (word, 0..) |c, j| lower[j] = std.ascii.toLower(c);

            const gop = try counts.getOrPut(lower);
            if (gop.found_existing) {
                gop.value_ptr.* += 1;
            } else {
                gop.key_ptr.* = try allocator.dupe(u8, lower);
                gop.value_ptr.* = 1;
            }
        } else {
            i += 1;
        }
    }

    const Entry = struct {
        word: []const u8,
        count: u64,
    };

    var entries: std.ArrayList(Entry) = .empty;
    defer entries.deinit(allocator);

    var it = counts.iterator();
    while (it.next()) |kv| {
        try entries.append(allocator, .{ .word = kv.key_ptr.*, .count = kv.value_ptr.* });
    }

    const lessThan = struct {
        fn f(_: void, a: Entry, b: Entry) bool {
            if (a.count != b.count) return a.count > b.count;
            return std.mem.lessThan(u8, a.word, b.word);
        }
    }.f;

    std.mem.sort(Entry, entries.items, {}, lessThan);

    var out_buf: [4096]u8 = undefined;
    var file_writer = std.fs.File.stdout().writer(&out_buf);
    const stdout = &file_writer.interface;

    for (entries.items) |e| {
        try stdout.print("{s} {d}\n", .{ e.word, e.count });
    }
    try stdout.flush();
}
