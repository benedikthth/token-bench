const std = @import("std");

pub fn main() !void {
    var stdin_buf: [4096]u8 = undefined;
    var stdout_buf: [4096]u8 = undefined;
    var stdin = std.fs.File.stdin().reader(&stdin_buf);
    var stdout = std.fs.File.stdout().writer(&stdout_buf);

    while (true) {
        const line = stdin.interface.takeDelimiterExclusive('\n') catch |err| {
            if (err == error.EndOfStream) break;
            return err;
        };

        var parser = Parser.init(line);
        const result = try parser.parse();
        try stdout.interface.print("{}\n", .{result});
    }
    try stdout.interface.flush();
}

const Parser = struct {
    input: []const u8,
    pos: usize = 0,

    fn init(input: []const u8) Parser {
        return Parser{
            .input = input,
            .pos = 0,
        };
    }

    fn skipSpaces(self: *Parser) void {
        while (self.pos < self.input.len and (self.input[self.pos] == ' ' or self.input[self.pos] == '\t')) {
            self.pos += 1;
        }
    }

    fn parseNumber(self: *Parser) i64 {
        self.skipSpaces();
        var num: i64 = 0;
        while (self.pos < self.input.len and self.input[self.pos] >= '0' and self.input[self.pos] <= '9') {
            num = num * 10 + (self.input[self.pos] - '0');
            self.pos += 1;
        }
        return num;
    }

    fn parsePrimary(self: *Parser) i64 {
        self.skipSpaces();

        if (self.pos < self.input.len and self.input[self.pos] == '(') {
            self.pos += 1;
            const result = self.parseAddSub();
            self.skipSpaces();
            if (self.pos < self.input.len and self.input[self.pos] == ')') {
                self.pos += 1;
            }
            return result;
        }

        return self.parseNumber();
    }

    fn parseMulDiv(self: *Parser) i64 {
        var result = self.parsePrimary();

        while (true) {
            self.skipSpaces();
            if (self.pos >= self.input.len) break;

            const ch = self.input[self.pos];
            if (ch == '*') {
                self.pos += 1;
                const right = self.parsePrimary();
                result = result * right;
            } else if (ch == '/') {
                self.pos += 1;
                const right = self.parsePrimary();
                result = @divTrunc(result, right);
            } else {
                break;
            }
        }

        return result;
    }

    fn parseAddSub(self: *Parser) !i64 {
        var result = try self.parseMulDiv();

        while (true) {
            self.skipSpaces();
            if (self.pos >= self.input.len) break;

            const ch = self.input[self.pos];
            if (ch == '+') {
                self.pos += 1;
                const right = try self.parseMulDiv();
                result = result + right;
            } else if (ch == '-') {
                self.pos += 1;
                const right = try self.parseMulDiv();
                result = result - right;
            } else {
                break;
            }
        }

        return result;
    }

    fn parse(self: *Parser) !i64 {
        return try self.parseAddSub();
    }
};
