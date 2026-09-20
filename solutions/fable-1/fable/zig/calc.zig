const std = @import("std");

const Parser = struct {
    s: []const u8,
    i: usize = 0,

    fn skip(p: *Parser) void {
        while (p.i < p.s.len and (p.s[p.i] == ' ' or p.s[p.i] == '\t' or p.s[p.i] == '\r')) : (p.i += 1) {}
    }

    fn peek(p: *Parser) u8 {
        p.skip();
        return if (p.i < p.s.len) p.s[p.i] else 0;
    }

    fn expr(p: *Parser) i128 {
        var v = p.term();
        while (true) {
            const c = p.peek();
            if (c == '+') {
                p.i += 1;
                v +%= p.term();
            } else if (c == '-') {
                p.i += 1;
                v -%= p.term();
            } else break;
        }
        return v;
    }

    fn term(p: *Parser) i128 {
        var v = p.factor();
        while (true) {
            const c = p.peek();
            if (c == '*') {
                p.i += 1;
                v *%= p.factor();
            } else if (c == '/') {
                p.i += 1;
                const d = p.factor();
                v = if (d == 0) 0 else @divTrunc(v, d);
            } else break;
        }
        return v;
    }

    fn factor(p: *Parser) i128 {
        const c = p.peek();
        if (c == '(') {
            p.i += 1;
            const v = p.expr();
            if (p.peek() == ')') p.i += 1;
            return v;
        }
        if (c == '-') {
            p.i += 1;
            return -%p.factor();
        }
        if (c == '+') {
            p.i += 1;
            return p.factor();
        }
        var v: i128 = 0;
        while (p.i < p.s.len and p.s[p.i] >= '0' and p.s[p.i] <= '9') : (p.i += 1) {
            v = v *% 10 +% @as(i128, p.s[p.i] - '0');
        }
        return v;
    }
};

fn readAllStdin(alloc: std.mem.Allocator) ![]u8 {
    var list = std.ArrayListUnmanaged(u8){};
    var buf: [65536]u8 = undefined;
    const fd = std.fs.File.stdin().handle;
    while (true) {
        const n = try std.posix.read(fd, &buf);
        if (n == 0) break;
        try list.appendSlice(alloc, buf[0..n]);
    }
    return list.toOwnedSlice(alloc);
}

fn writeAll(fd: std.posix.fd_t, data: []const u8) !void {
    var off: usize = 0;
    while (off < data.len) {
        off += try std.posix.write(fd, data[off..]);
    }
}

pub fn main() !void {
    var gpa = std.heap.page_allocator;
    const input = try readAllStdin(gpa);
    var out = std.ArrayListUnmanaged(u8){};
    var it = std.mem.splitScalar(u8, input, '\n');
    while (it.next()) |raw| {
        const line = std.mem.trim(u8, raw, " \t\r");
        if (line.len == 0) continue;
        var p = Parser{ .s = line };
        const v = p.expr();
        var nb: [64]u8 = undefined;
        const s = std.fmt.bufPrint(&nb, "{d}\n", .{v}) catch unreachable;
        try out.appendSlice(gpa, s);
    }
    _ = &gpa;
    try writeAll(std.fs.File.stdout().handle, out.items);
}
