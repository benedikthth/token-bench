const std = @import("std");

const Item = struct { d: u64, v: usize };

fn lessThan(_: void, a: Item, b: Item) std.math.Order {
    return std.math.order(a.d, b.d);
}

pub fn main() !void {
    var gpa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer gpa.deinit();
    const alloc = gpa.allocator();

    const input = try std.fs.File.stdin().readToEndAlloc(alloc, 1 << 30);
    var it = std.mem.tokenizeAny(u8, input, " \t\r\n");

    const n = try std.fmt.parseInt(usize, it.next().?, 10);
    const m = try std.fmt.parseInt(usize, it.next().?, 10);

    const eu = try alloc.alloc(usize, m);
    const ev = try alloc.alloc(usize, m);
    const ew = try alloc.alloc(u64, m);
    const deg = try alloc.alloc(usize, n + 1);
    @memset(deg, 0);
    for (0..m) |i| {
        eu[i] = try std.fmt.parseInt(usize, it.next().?, 10);
        ev[i] = try std.fmt.parseInt(usize, it.next().?, 10);
        ew[i] = try std.fmt.parseInt(u64, it.next().?, 10);
        deg[eu[i] + 1] += 1;
        deg[ev[i] + 1] += 1;
    }
    const s = try std.fmt.parseInt(usize, it.next().?, 10);
    const t = try std.fmt.parseInt(usize, it.next().?, 10);

    for (1..n + 1) |i| deg[i] += deg[i - 1];
    const pos = try alloc.alloc(usize, n);
    for (0..n) |i| pos[i] = deg[i];
    const adjTo = try alloc.alloc(usize, 2 * m);
    const adjW = try alloc.alloc(u64, 2 * m);
    for (0..m) |i| {
        adjTo[pos[eu[i]]] = ev[i];
        adjW[pos[eu[i]]] = ew[i];
        pos[eu[i]] += 1;
        adjTo[pos[ev[i]]] = eu[i];
        adjW[pos[ev[i]]] = ew[i];
        pos[ev[i]] += 1;
    }

    const inf = std.math.maxInt(u64);
    const dist = try alloc.alloc(u64, n);
    @memset(dist, inf);
    dist[s] = 0;

    var pq = std.PriorityQueue(Item, void, lessThan).init(alloc, {});
    try pq.add(.{ .d = 0, .v = s });
    while (pq.removeOrNull()) |cur| {
        if (cur.d != dist[cur.v]) continue;
        if (cur.v == t) break;
        var k = deg[cur.v];
        while (k < deg[cur.v + 1]) : (k += 1) {
            const nd = cur.d + adjW[k];
            const to = adjTo[k];
            if (nd < dist[to]) {
                dist[to] = nd;
                try pq.add(.{ .d = nd, .v = to });
            }
        }
    }

    var buf: [32]u8 = undefined;
    const out = if (dist[t] == inf)
        try std.fmt.bufPrint(&buf, "-1\n", .{})
    else
        try std.fmt.bufPrint(&buf, "{d}\n", .{dist[t]});
    try std.fs.File.stdout().writeAll(out);
}
