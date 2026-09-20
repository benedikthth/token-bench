const std = @import("std");
const posix = std.posix;

pub fn main() !void {
    var input_buf: [1024]u8 = undefined;

    while (true) {
        const n = posix.read(0, &input_buf) catch break;
        if (n == 0) break; // EOF

        var line = input_buf[0..n];
        // Remove trailing newline if present
        if (line.len > 0 and line[line.len - 1] == '\n') {
            line = line[0 .. line.len - 1];
        }

        var parser = Parser.init(line);
        const result = parser.parseExpression() catch continue;

        var output_buf: [64]u8 = undefined;
        const output = std.fmt.bufPrint(&output_buf, "{}\n", .{result}) catch continue;
        _ = posix.write(1, output) catch continue;
    }
}

const Parser = struct {
    input: []const u8,
    pos: usize = 0,

    fn init(input: []const u8) Parser {
        return Parser{ .input = input };
    }

    fn skipWhitespace(self: *Parser) void {
        while (self.pos < self.input.len and self.input[self.pos] == ' ') {
            self.pos += 1;
        }
    }

    fn parseExpression(self: *Parser) anyerror!i64 {
        var result = try self.parseTerm();

        while (true) {
            self.skipWhitespace();
            if (self.pos >= self.input.len) break;

            const ch = self.input[self.pos];
            if (ch == '+') {
                self.pos += 1;
                const right = try self.parseTerm();
                result = result + right;
            } else if (ch == '-') {
                self.pos += 1;
                const right = try self.parseTerm();
                result = result - right;
            } else {
                break;
            }
        }

        return result;
    }

    fn parseTerm(self: *Parser) anyerror!i64 {
        var result = try self.parseFactor();

        while (true) {
            self.skipWhitespace();
            if (self.pos >= self.input.len) break;

            const ch = self.input[self.pos];
            if (ch == '*') {
                self.pos += 1;
                const right = try self.parseFactor();
                result = result * right;
            } else if (ch == '/') {
                self.pos += 1;
                const right = try self.parseFactor();
                result = @divTrunc(result, right);
            } else {
                break;
            }
        }

        return result;
    }

    fn parseFactor(self: *Parser) anyerror!i64 {
        self.skipWhitespace();

        if (self.pos >= self.input.len) {
            return error.UnexpectedEOF;
        }

        if (self.input[self.pos] == '(') {
            self.pos += 1;
            const result = try self.parseExpression();
            self.skipWhitespace();
            if (self.pos >= self.input.len or self.input[self.pos] != ')') {
                return error.MissingClosingParen;
            }
            self.pos += 1;
            return result;
        }

        // Parse number
        var num: i64 = 0;
        if (self.pos >= self.input.len or self.input[self.pos] < '0' or self.input[self.pos] > '9') {
            return error.ExpectedNumber;
        }

        while (self.pos < self.input.len and self.input[self.pos] >= '0' and self.input[self.pos] <= '9') {
            num = num * 10 + (self.input[self.pos] - '0');
            self.pos += 1;
        }

        return num;
    }
};
