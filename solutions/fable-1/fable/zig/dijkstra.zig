const std = @import("std");

const Item = struct {
    dist: u64,
    node: u32,
};

fn lessThan(_: void, a: Item, b: Item) std.math.Order {
    return std.math.order(a.dist, b.dist);
}

const Parser = struct {
    buf: []const u8,
    pos: usize = 0,

    fn next(self: *Parser) ?u64 {
        while (self.pos < self.buf.len and (self.buf[self.pos] < '0' or self.buf[self.pos] > '9')) : (self.pos += 1) {}
        if (self.pos >= self.buf.len) return null;
        var v: u64 = 0;
        while (self.pos < self.buf.len and self.buf[self.pos] >= '0' and self.buf[self.pos] <= '9') : (self.pos += 1) {
            v = v * 10 + (self.buf[self.pos] - '0');
        }
        return v;
    }
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    const stdin = std.fs.File.stdin();
    const input = try stdin.readToEndAlloc(alloc, 1 << 30);

    var p = Parser{ .buf = input };
    const n: usize = @intCast(p.next() orelse 0);
    const m: usize = @intCast(p.next() orelse 0);

    const eu = try alloc.alloc(u32, m);
    const ev = try alloc.alloc(u32, m);
    const ew = try alloc.alloc(u64, m);
    const deg = try alloc.alloc(u32, n + 1);
    @memset(deg, 0);

    var i: usize = 0;
    while (i < m) : (i += 1) {
        const u: u32 = @intCast(p.next() orelse 0);
        const v: u32 = @intCast(p.next() orelse 0);
        const w: u64 = p.next() orelse 0;
        eu[i] = u;
        ev[i] = v;
        ew[i] = w;
        if (u < n) deg[u] += 1;
        if (v < n) deg[v] += 1;
    }
    const s: usize = @intCast(p.next() orelse 0);
    const t: usize = @intCast(p.next() orelse 0);

    // CSR
    const off = try alloc.alloc(u32, n + 1);
    off[0] = 0;
    i = 0;
    while (i < n) : (i += 1) off[i + 1] = off[i] + deg[i];
    const total = off[n];
    const adjTo = try alloc.alloc(u32, total);
    const adjW = try alloc.alloc(u64, total);
    const fill = try alloc.alloc(u32, n);
    @memcpy(fill, off[0..n]);
    i = 0;
    while (i < m) : (i += 1) {
        const u = eu[i];
        const v = ev[i];
        if (u >= n or v >= n) continue;
        adjTo[fill[u]] = v;
        adjW[fill[u]] = ew[i];
        fill[u] += 1;
        adjTo[fill[v]] = u;
        adjW[fill[v]] = ew[i];
        fill[v] += 1;
    }

    const stdout = std.fs.File.stdout();

    if (s == t) {
        try stdout.writeAll("0\n");
        return;
    }
    if (s >= n or t >= n) {
        try stdout.writeAll("-1\n");
        return;
    }

    const inf = std.math.maxInt(u64);
    const dist = try alloc.alloc(u64, n);
    @memset(dist, inf);
    dist[s] = 0;

    var heap = std.PriorityQueue(Item, void, lessThan).init(alloc, {});
    try heap.add(.{ .dist = 0, .node = @intCast(s) });

    while (heap.removeOrNull()) |it| {
        if (it.dist > dist[it.node]) continue;
        if (it.node == t) break;
        const u = it.node;
        var k = off[u];
        const end = off[u + 1];
        while (k < end) : (k += 1) {
            const v = adjTo[k];
            const nd = it.dist + adjW[k];
            if (nd < dist[v]) {
                dist[v] = nd;
                try heap.add(.{ .dist = nd, .node = v });
            }
        }
    }

    var outbuf: [64]u8 = undefined;
    if (dist[t] == inf) {
        try stdout.writeAll("-1\n");
    } else {
        const str = try std.fmt.bufPrint(&outbuf, "{d}\n", .{dist[t]});
        try stdout.writeAll(str);
    }
}
