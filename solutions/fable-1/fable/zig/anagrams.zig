const std = @import("std");

const Entry = struct {
    key: []const u8,
    word: []const u8,
};

const Group = struct {
    start: usize,
    end: usize,
    first: []const u8,
};

fn entryLess(_: void, a: Entry, b: Entry) bool {
    switch (std.mem.order(u8, a.key, b.key)) {
        .lt => return true,
        .gt => return false,
        .eq => return std.mem.order(u8, a.word, b.word) == .lt,
    }
}

fn groupLess(_: void, a: Group, b: Group) bool {
    return std.mem.order(u8, a.first, b.first) == .lt;
}

fn readAll(alloc: std.mem.Allocator) ![]u8 {
    var data: std.ArrayList(u8) = .empty;
    var buf: [1 << 16]u8 = undefined;
    const fd = std.posix.STDIN_FILENO;
    while (true) {
        const n = try std.posix.read(fd, &buf);
        if (n == 0) break;
        try data.appendSlice(alloc, buf[0..n]);
    }
    return data.items;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    const input = try readAll(alloc);

    var entries: std.ArrayList(Entry) = .empty;
    var it = std.mem.splitScalar(u8, input, '\n');
    while (it.next()) |raw| {
        const line = std.mem.trim(u8, raw, " \t\r");
        if (line.len == 0) continue;
        // Build sorted key via counting sort over bytes.
        var counts = [_]u32{0} ** 256;
        for (line) |c| counts[c] += 1;
        const key = try alloc.alloc(u8, line.len);
        var pos: usize = 0;
        for (counts, 0..) |cnt, c| {
            var k: u32 = 0;
            while (k < cnt) : (k += 1) {
                key[pos] = @intCast(c);
                pos += 1;
            }
        }
        try entries.append(alloc, .{ .key = key, .word = line });
    }

    const items = entries.items;
    std.mem.sort(Entry, items, {}, entryLess);

    var groups: std.ArrayList(Group) = .empty;
    var i: usize = 0;
    while (i < items.len) {
        var j = i + 1;
        while (j < items.len and std.mem.eql(u8, items[j].key, items[i].key)) : (j += 1) {}
        try groups.append(alloc, .{ .start = i, .end = j, .first = items[i].word });
        i = j;
    }
    std.mem.sort(Group, groups.items, {}, groupLess);

    var out: std.ArrayList(u8) = .empty;
    for (groups.items) |g| {
        var k = g.start;
        while (k < g.end) : (k += 1) {
            if (k != g.start) try out.append(alloc, ' ');
            try out.appendSlice(alloc, items[k].word);
        }
        try out.append(alloc, '\n');
    }

    const stdout = std.fs.File.stdout();
    try stdout.writeAll(out.items);
}
