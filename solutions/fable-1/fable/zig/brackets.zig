const std = @import("std");

fn readAllStdin(allocator: std.mem.Allocator) ![]u8 {
    const stdin = std.fs.File.stdin();
    var buf = try allocator.alloc(u8, 1 << 16);
    var len: usize = 0;
    while (true) {
        if (len == buf.len) {
            buf = try allocator.realloc(buf, buf.len * 2);
        }
        const n = try stdin.read(buf[len..]);
        if (n == 0) break;
        len += n;
    }
    return buf[0..len];
}

fn balanced(line: []const u8, stack: []u8) bool {
    var sp: usize = 0;
    for (line) |c| {
        switch (c) {
            '(', '[', '{' => {
                stack[sp] = c;
                sp += 1;
            },
            ')' => {
                if (sp == 0 or stack[sp - 1] != '(') return false;
                sp -= 1;
            },
            ']' => {
                if (sp == 0 or stack[sp - 1] != '[') return false;
                sp -= 1;
            },
            '}' => {
                if (sp == 0 or stack[sp - 1] != '{') return false;
                sp -= 1;
            },
            else => {},
        }
    }
    return sp == 0;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const input = try readAllStdin(allocator);
    const stack = try allocator.alloc(u8, input.len + 1);

    var out = try allocator.alloc(u8, input.len + 16);
    var olen: usize = 0;

    var it = std.mem.splitScalar(u8, input, '\n');
    var first = true;
    while (it.next()) |raw| {
        // Skip the empty tail after a final newline (but keep a leading-only empty input? no lines then).
        if (it.peek() == null and raw.len == 0) {
            if (first) break; // empty input: no lines
            break;
        }
        first = false;
        var line = raw;
        if (line.len > 0 and line[line.len - 1] == '\r') line = line[0 .. line.len - 1];
        const ans: []const u8 = if (balanced(line, stack)) "yes\n" else "no\n";
        if (olen + ans.len > out.len) {
            out = try allocator.realloc(out, out.len * 2 + ans.len);
        }
        @memcpy(out[olen .. olen + ans.len], ans);
        olen += ans.len;
    }

    try std.fs.File.stdout().writeAll(out[0..olen]);
}
