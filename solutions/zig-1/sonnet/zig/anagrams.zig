const std = @import("std");

fn lessThanStr(_: void, a: []const u8, b: []const u8) bool {
    return std.mem.lessThan(u8, a, b);
}

const Group = struct {
    words: [][]const u8,
};

fn lessThanGroup(_: void, a: Group, b: Group) bool {
    return std.mem.lessThan(u8, a.words[0], b.words[0]);
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const stdin = std.fs.File.stdin();
    const input = try stdin.readToEndAlloc(allocator, 1 << 30);

    var map = std.StringHashMap(std.ArrayList([]const u8)).init(allocator);

    var it = std.mem.splitScalar(u8, input, '\n');
    while (it.next()) |raw_line| {
        var line = raw_line;
        if (line.len > 0 and line[line.len - 1] == '\r') {
            line = line[0 .. line.len - 1];
        }
        // trim any trailing/leading whitespace just in case
        line = std.mem.trim(u8, line, " \t");
        if (line.len == 0) continue;

        const word = try allocator.dupe(u8, line);

        const key = try allocator.dupe(u8, word);
        std.mem.sort(u8, key, {}, std.sort.asc(u8));

        const entry = try map.getOrPut(key);
        if (!entry.found_existing) {
            entry.value_ptr.* = std.ArrayList([]const u8).empty;
        }
        try entry.value_ptr.append(allocator, word);
    }

    var groups = std.ArrayList(Group).empty;
    var value_it = map.valueIterator();
    while (value_it.next()) |list_ptr| {
        const words = try list_ptr.toOwnedSlice(allocator);
        std.mem.sort([]const u8, words, {}, lessThanStr);
        try groups.append(allocator, Group{ .words = words });
    }

    const groups_slice = try groups.toOwnedSlice(allocator);
    std.mem.sort(Group, groups_slice, {}, lessThanGroup);

    var buf = std.ArrayList(u8).empty;
    for (groups_slice) |group| {
        for (group.words, 0..) |word, idx| {
            if (idx != 0) try buf.append(allocator, ' ');
            try buf.appendSlice(allocator, word);
        }
        try buf.append(allocator, '\n');
    }

    const stdout = std.fs.File.stdout();
    try stdout.writeAll(buf.items);
}
