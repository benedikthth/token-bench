const std = @import("std");

const Entry = struct { word: []const u8, count: u32 };

fn lessThan(_: void, a: Entry, b: Entry) bool {
    if (a.count != b.count) return a.count > b.count;
    return std.mem.lessThan(u8, a.word, b.word);
}

pub fn main() !void {
    const gpa = std.heap.page_allocator;
    var inbuf: [4096]u8 = undefined;
    var fr = std.fs.File.stdin().reader(&inbuf);
    const data = try fr.interface.allocRemaining(gpa, .unlimited);

    for (data) |*c| c.* = std.ascii.toLower(c.*);

    var map = std.StringHashMap(u32).init(gpa);
    var i: usize = 0;
    while (i < data.len) {
        if (!std.ascii.isAlphabetic(data[i])) {
            i += 1;
            continue;
        }
        const start = i;
        while (i < data.len and std.ascii.isAlphabetic(data[i])) i += 1;
        const gop = try map.getOrPut(data[start..i]);
        if (gop.found_existing) gop.value_ptr.* += 1 else gop.value_ptr.* = 1;
    }

    var list: std.ArrayList(Entry) = .empty;
    var it = map.iterator();
    while (it.next()) |kv| try list.append(gpa, .{ .word = kv.key_ptr.*, .count = kv.value_ptr.* });
    std.mem.sort(Entry, list.items, {}, lessThan);

    var outbuf: [65536]u8 = undefined;
    var fw = std.fs.File.stdout().writer(&outbuf);
    const w = &fw.interface;
    for (list.items) |e| try w.print("{s} {d}\n", .{ e.word, e.count });
    try w.flush();
}
