const std = @import("std");

const Edge = struct {
    to: usize,
    w: u64,
};

const QItem = struct {
    dist: u64,
    node: usize,
};

fn lessThan(context: void, a: QItem, b: QItem) std.math.Order {
    _ = context;
    return std.math.order(a.dist, b.dist);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdin = std.fs.File.stdin();
    const input = try stdin.readToEndAlloc(allocator, 1 << 30);
    defer allocator.free(input);

    var it = std.mem.tokenizeAny(u8, input, " \t\r\n");

    const n_str = it.next() orelse return error.InvalidInput;
    const m_str = it.next() orelse return error.InvalidInput;
    const n = try std.fmt.parseInt(usize, n_str, 10);
    const m = try std.fmt.parseInt(usize, m_str, 10);

    var adj = try allocator.alloc(std.ArrayListUnmanaged(Edge), n);
    defer {
        for (adj) |*list| list.deinit(allocator);
        allocator.free(adj);
    }
    for (adj) |*list| list.* = .{};

    var i: usize = 0;
    while (i < m) : (i += 1) {
        const u_str = it.next() orelse return error.InvalidInput;
        const v_str = it.next() orelse return error.InvalidInput;
        const w_str = it.next() orelse return error.InvalidInput;
        const u = try std.fmt.parseInt(usize, u_str, 10);
        const v = try std.fmt.parseInt(usize, v_str, 10);
        const w = try std.fmt.parseInt(u64, w_str, 10);
        try adj[u].append(allocator, .{ .to = v, .w = w });
        try adj[v].append(allocator, .{ .to = u, .w = w });
    }

    const s_str = it.next() orelse return error.InvalidInput;
    const t_str = it.next() orelse return error.InvalidInput;
    const s = try std.fmt.parseInt(usize, s_str, 10);
    const t = try std.fmt.parseInt(usize, t_str, 10);

    const stdout = std.fs.File.stdout().deprecatedWriter();

    if (s == t) {
        try stdout.print("0\n", .{});
        return;
    }

    const INF: u64 = std.math.maxInt(u64);
    var dist = try allocator.alloc(u64, n);
    defer allocator.free(dist);
    for (dist) |*d| d.* = INF;
    dist[s] = 0;

    var visited = try allocator.alloc(bool, n);
    defer allocator.free(visited);
    for (visited) |*b| b.* = false;

    var pq = std.PriorityQueue(QItem, void, lessThan).init(allocator, {});
    defer pq.deinit();

    try pq.add(.{ .dist = 0, .node = s });

    while (pq.count() > 0) {
        const cur = pq.remove();
        if (visited[cur.node]) continue;
        visited[cur.node] = true;
        if (cur.node == t) break;

        for (adj[cur.node].items) |e| {
            if (visited[e.to]) continue;
            const nd = cur.dist + e.w;
            if (nd < dist[e.to]) {
                dist[e.to] = nd;
                try pq.add(.{ .dist = nd, .node = e.to });
            }
        }
    }

    if (dist[t] == INF) {
        try stdout.print("-1\n", .{});
    } else {
        try stdout.print("{d}\n", .{dist[t]});
    }
}
