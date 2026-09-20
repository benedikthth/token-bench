const std = @import("std");

const Parser = struct {
    s: []const u8,
    i: usize = 0,

    fn skip(p: *Parser) void {
        while (p.i < p.s.len and (p.s[p.i] == ' ' or p.s[p.i] == '\t')) p.i += 1;
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
                v += p.term();
            } else if (c == '-') {
                p.i += 1;
                v -= p.term();
            } else return v;
        }
    }

    fn term(p: *Parser) i128 {
        var v = p.factor();
        while (true) {
            const c = p.peek();
            if (c == '*') {
                p.i += 1;
                v *= p.factor();
            } else if (c == '/') {
                p.i += 1;
                v = @divTrunc(v, p.factor());
            } else return v;
        }
    }

    fn factor(p: *Parser) i128 {
        const c = p.peek();
        if (c == '(') {
            p.i += 1;
            const v = p.expr();
            if (p.peek() == ')') p.i += 1;
            return v;
        }
        var v: i128 = 0;
        while (p.i < p.s.len and p.s[p.i] >= '0' and p.s[p.i] <= '9') : (p.i += 1) {
            v = v * 10 + (p.s[p.i] - '0');
        }
        return v;
    }
};

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    var inbuf: [4096]u8 = undefined;
    var r = std.fs.File.stdin().reader(&inbuf);
    const data = try r.interface.allocRemaining(alloc, .unlimited);
    var outbuf: [4096]u8 = undefined;
    var w = std.fs.File.stdout().writer(&outbuf);
    const out = &w.interface;

    var it = std.mem.splitScalar(u8, data, '\n');
    while (it.next()) |raw| {
        const line = std.mem.trim(u8, raw, " \t\r");
        if (line.len == 0) continue;
        var p = Parser{ .s = line };
        try out.print("{d}\n", .{p.expr()});
    }
    try out.flush();
}
