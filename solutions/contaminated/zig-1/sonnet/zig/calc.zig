const std = @import("std");

const Parser = struct {
    s: []const u8,
    i: usize,

    fn skipSpaces(self: *Parser) void {
        while (self.i < self.s.len and self.s[self.i] == ' ') : (self.i += 1) {}
    }

    fn peek(self: *Parser) ?u8 {
        self.skipSpaces();
        if (self.i < self.s.len) return self.s[self.i];
        return null;
    }

    fn parseExpr(self: *Parser) i64 {
        var value = self.parseTerm();
        while (true) {
            const c = self.peek() orelse break;
            if (c == '+') {
                self.i += 1;
                value += self.parseTerm();
            } else if (c == '-') {
                self.i += 1;
                value -= self.parseTerm();
            } else break;
        }
        return value;
    }

    fn parseTerm(self: *Parser) i64 {
        var value = self.parseFactor();
        while (true) {
            const c = self.peek() orelse break;
            if (c == '*') {
                self.i += 1;
                value *= self.parseFactor();
            } else if (c == '/') {
                self.i += 1;
                const rhs = self.parseFactor();
                value = @divTrunc(value, rhs);
            } else break;
        }
        return value;
    }

    fn parseFactor(self: *Parser) i64 {
        const c = self.peek().?;
        if (c == '(') {
            self.i += 1;
            const value = self.parseExpr();
            self.skipSpaces();
            if (self.i < self.s.len and self.s[self.i] == ')') self.i += 1;
            return value;
        }
        return self.parseNumber();
    }

    fn parseNumber(self: *Parser) i64 {
        self.skipSpaces();
        var value: i64 = 0;
        while (self.i < self.s.len and self.s[self.i] >= '0' and self.s[self.i] <= '9') : (self.i += 1) {
            value = value * 10 + (self.s[self.i] - '0');
        }
        return value;
    }
};

fn isBlank(line: []const u8) bool {
    for (line) |ch| {
        if (ch != ' ' and ch != '\t') return false;
    }
    return true;
}

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const allocator = arena_state.allocator();

    const input = try std.fs.File.stdin().readToEndAlloc(allocator, 1 << 30);

    var stdout_buf: [4096]u8 = undefined;
    var stdout = std.fs.File.stdout().writer(&stdout_buf);

    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |raw_line| {
        var line = raw_line;
        if (line.len > 0 and line[line.len - 1] == '\r') line = line[0 .. line.len - 1];
        if (isBlank(line)) continue;

        var parser = Parser{ .s = line, .i = 0 };
        const result = parser.parseExpr();
        try stdout.interface.print("{d}\n", .{result});
    }

    try stdout.interface.flush();
}
