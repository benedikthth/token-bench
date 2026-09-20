const std = @import("std");

const Item = struct { key: []const u8, word: []const u8 };
const Group = struct { start: usize, end: usize };

fn itemLess(_: void, a: Item, b: Item) bool {
    const o = std.mem.order(u8, a.key, b.key);
    if (o != .eq) return o == .lt;
    return std.mem.lessThan(u8, a.word, b.word);
}

fn groupLess(items: []const Item, a: Group, b: Group) bool {
    return std.mem.lessThan(u8, items[a.start].word, items[b.start].word);
}

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const input = try std.fs.File.stdin().readToEndAlloc(alloc, 1 << 30);

    var items: std.ArrayList(Item) = .empty;
    var it = std.mem.splitScalar(u8, input, '\n');
    while (it.next()) |raw| {
        const w = std.mem.trim(u8, raw, " \r\t");
        if (w.len == 0) continue;
        const k = try alloc.dupe(u8, w);
        std.mem.sort(u8, k, {}, std.sort.asc(u8));
        try items.append(alloc, .{ .key = k, .word = w });
    }
    std.mem.sort(Item, items.items, {}, itemLess);

    var groups: std.ArrayList(Group) = .empty;
    var i: usize = 0;
    while (i < items.items.len) {
        var j = i + 1;
        while (j < items.items.len and std.mem.eql(u8, items.items[j].key, items.items[i].key)) j += 1;
        try groups.append(alloc, .{ .start = i, .end = j });
        i = j;
    }
    std.mem.sort(Group, groups.items, @as([]const Item, items.items), groupLess);

    var out: std.ArrayList(u8) = .empty;
    for (groups.items) |g| {
        for (items.items[g.start..g.end], 0..) |item, idx| {
            if (idx > 0) try out.append(alloc, ' ');
            try out.appendSlice(alloc, item.word);
        }
        try out.append(alloc, '\n');
    }
    try std.fs.File.stdout().writeAll(out.items);
}
