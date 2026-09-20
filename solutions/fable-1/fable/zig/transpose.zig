const std = @import("std");

fn readAllStdin(alloc: std.mem.Allocator) ![]u8 {
    const stdin = std.fs.File{ .handle = 0 };
    var buf = std.ArrayListUnmanaged(u8){};
    var chunk: [1 << 16]u8 = undefined;
    while (true) {
        const n = try stdin.read(&chunk);
        if (n == 0) break;
        try buf.appendSlice(alloc, chunk[0..n]);
    }
    return buf.items;
}

const Parser = struct {
    data: []const u8,
    pos: usize = 0,

    fn next(self: *Parser) ?i64 {
        while (self.pos < self.data.len) {
            const c = self.data[self.pos];
            if (c == '-' or (c >= '0' and c <= '9')) break;
            self.pos += 1;
        }
        if (self.pos >= self.data.len) return null;
        var neg = false;
        if (self.data[self.pos] == '-') {
            neg = true;
            self.pos += 1;
        }
        var v: i64 = 0;
        while (self.pos < self.data.len) {
            const c = self.data[self.pos];
            if (c < '0' or c > '9') break;
            v = v * 10 + @as(i64, c - '0');
            self.pos += 1;
        }
        return if (neg) -v else v;
    }
};

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const input = try readAllStdin(alloc);
    var p = Parser{ .data = input };

    const r: usize = @intCast(p.next() orelse return);
    const c: usize = @intCast(p.next() orelse return);

    const mat = try alloc.alloc(i64, r * c);
    for (0..r * c) |i| {
        mat[i] = p.next() orelse 0;
    }

    var out = std.ArrayListUnmanaged(u8){};
    try out.ensureTotalCapacity(alloc, r * c * 12 + c + 16);
    var tmp: [24]u8 = undefined;

    for (0..c) |j| {
        for (0..r) |i| {
            if (i != 0) try out.append(alloc, ' ');
            const s = std.fmt.bufPrint(&tmp, "{d}", .{mat[i * c + j]}) catch unreachable;
            try out.appendSlice(alloc, s);
        }
        try out.append(alloc, '\n');
    }

    const stdout = std.fs.File{ .handle = 1 };
    try stdout.writeAll(out.items);
}
