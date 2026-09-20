const std = @import("std");

const Edge = struct { v: usize, w: usize };

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read all input into a buffer
    var input_buf: [100000]u8 = undefined;
    const stdin = try std.fs.openFileAbsolute("/dev/stdin", .{ .mode = .read_only });
    defer stdin.close();

    const bytes_read = try stdin.readAll(&input_buf);
    const input = input_buf[0..bytes_read];

    // Simple line splitter
    var lines = std.mem.splitSequence(u8, input, "\n");

    // Parse N and M
    const first_line = lines.next() orelse return;
    var first_parts = std.mem.splitSequence(u8, first_line, " ");
    const n = try std.fmt.parseInt(usize, first_parts.next() orelse return, 10);
    const m = try std.fmt.parseInt(usize, first_parts.next() orelse return, 10);

    // Create adjacency list
    var adj_lists: [300]EdgeList = undefined;
    for (0..n) |i| {
        adj_lists[i] = EdgeList.init(allocator);
    }
    defer {
        for (0..n) |i| {
            adj_lists[i].deinit();
        }
    }

    // Read edges
    for (0..m) |_| {
        const edge_line = lines.next() orelse return;
        var edge_parts = std.mem.splitSequence(u8, edge_line, " ");
        const u = try std.fmt.parseInt(usize, edge_parts.next() orelse return, 10);
        const v = try std.fmt.parseInt(usize, edge_parts.next() orelse return, 10);
        const w = try std.fmt.parseInt(usize, edge_parts.next() orelse return, 10);

        try adj_lists[u].append(.{ .v = v, .w = w });
        try adj_lists[v].append(.{ .v = u, .w = w });
    }

    // Read s and t
    const st_line = lines.next() orelse return;
    var st_parts = std.mem.splitSequence(u8, st_line, " ");
    const s = try std.fmt.parseInt(usize, st_parts.next() orelse return, 10);
    const t = try std.fmt.parseInt(usize, st_parts.next() orelse return, 10);

    // Special case: start equals target
    if (s == t) {
        try printResult(0);
        return;
    }

    // Dijkstra's algorithm
    var dist = try allocator.alloc(i64, n);
    defer allocator.free(dist);

    for (0..n) |i| {
        dist[i] = std.math.maxInt(i64);
    }
    dist[s] = 0;

    var visited = try allocator.alloc(bool, n);
    defer allocator.free(visited);
    @memset(visited, false);

    // Run n iterations of Dijkstra
    for (0..n) |_| {
        var min_dist: i64 = std.math.maxInt(i64);
        var min_node: usize = 0;

        // Find unvisited node with minimum distance
        for (0..n) |i| {
            if (!visited[i] and dist[i] < min_dist) {
                min_dist = dist[i];
                min_node = i;
            }
        }

        // No more reachable nodes
        if (min_dist == std.math.maxInt(i64)) break;

        visited[min_node] = true;

        // Update distances to neighbors
        for (adj_lists[min_node].items()) |edge| {
            const v = edge.v;
            const w = @as(i64, @intCast(edge.w));
            if (!visited[v] and dist[min_node] + w < dist[v]) {
                dist[v] = dist[min_node] + w;
            }
        }
    }

    // Output result
    if (dist[t] == std.math.maxInt(i64)) {
        try printResult(-1);
    } else {
        try printResult(dist[t]);
    }
}

const EdgeList = struct {
    data: []Edge,
    len: usize,
    allocator: std.mem.Allocator,

    fn init(allocator: std.mem.Allocator) EdgeList {
        return EdgeList{
            .data = &[_]Edge{},
            .len = 0,
            .allocator = allocator,
        };
    }

    fn append(self: *EdgeList, edge: Edge) !void {
        if (self.len >= self.data.len) {
            const new_cap = if (self.data.len == 0) 10 else self.data.len * 2;
            const new_data = try self.allocator.alloc(Edge, new_cap);
            if (self.len > 0) {
                @memcpy(new_data[0..self.len], self.data[0..self.len]);
                self.allocator.free(self.data);
            }
            self.data = new_data;
        }
        self.data[self.len] = edge;
        self.len += 1;
    }

    fn items(self: EdgeList) []Edge {
        return self.data[0..self.len];
    }

    fn deinit(self: EdgeList) void {
        if (self.data.len > 0) {
            self.allocator.free(self.data);
        }
    }
};

fn printResult(value: i64) !void {
    const stdout = try std.fs.openFileAbsolute("/dev/stdout", .{ .mode = .write_only });
    defer stdout.close();

    var buf: [100]u8 = undefined;
    const len = try std.fmt.bufPrint(&buf, "{}\n", .{value});
    _ = try stdout.writeAll(len);
}
