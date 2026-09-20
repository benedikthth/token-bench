const std = @import("std");

const Parser = struct {
    s: []const u8,
    pos: usize = 0,

    fn skipSpaces(p: *Parser) void {
        while (p.pos < p.s.len and p.s[p.pos] == ' ') : (p.pos += 1) {}
    }

    fn peek(p: *Parser) ?u8 {
        p.skipSpaces();
        if (p.pos < p.s.len) return p.s[p.pos];
        return null;
    }

    fn parseExpr(p: *Parser) i64 {
        var value = p.parseTerm();
        while (true) {
            const c = p.peek() orelse break;
            if (c == '+') {
                p.pos += 1;
                value += p.parseTerm();
            } else if (c == '-') {
                p.pos += 1;
                value -= p.parseTerm();
            } else break;
        }
        return value;
    }

    fn parseTerm(p: *Parser) i64 {
        var value = p.parseFactor();
        while (true) {
            const c = p.peek() orelse break;
            if (c == '*') {
                p.pos += 1;
                value *= p.parseFactor();
            } else if (c == '/') {
                p.pos += 1;
                const rhs = p.parseFactor();
                value = @divTrunc(value, rhs);
            } else break;
        }
        return value;
    }

    fn parseFactor(p: *Parser) i64 {
        const c = p.peek() orelse return 0;
        if (c == '(') {
            p.pos += 1;
            const value = p.parseExpr();
            p.skipSpaces();
            if (p.pos < p.s.len and p.s[p.pos] == ')') p.pos += 1;
            return value;
        }
        return p.parseNumber();
    }

    fn parseNumber(p: *Parser) i64 {
        p.skipSpaces();
        var value: i64 = 0;
        while (p.pos < p.s.len and p.s[p.pos] >= '0' and p.s[p.pos] <= '9') : (p.pos += 1) {
            value = value * 10 + @as(i64, p.s[p.pos] - '0');
        }
        return value;
    }
};

pub fn main() !void {
    const stdin = std.fs.File.stdin();
    const stdout = std.fs.File.stdout();

    var input_buf: [65536]u8 = undefined;
    var file_reader = stdin.reader(&input_buf);
    const reader = &file_reader.interface;

    var output_buf: [65536]u8 = undefined;
    var file_writer = stdout.writer(&output_buf);
    const writer = &file_writer.interface;

    while (true) {
        const line = reader.takeDelimiterExclusive('\n') catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };
        var trimmed = line;
        if (trimmed.len > 0 and trimmed[trimmed.len - 1] == '\r') {
            trimmed = trimmed[0 .. trimmed.len - 1];
        }
        if (trimmed.len == 0) continue;

        var parser = Parser{ .s = trimmed };
        const result = parser.parseExpr();
        try writer.print("{d}\n", .{result});
    }

    try writer.flush();
}
