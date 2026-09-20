const std = @import("std");
const fs = std.fs;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdin_handle = try fs.cwd().openFile("/dev/stdin", .{ .mode = .read_only });
    defer stdin_handle.close();

    const stdout_handle = try fs.cwd().openFile("/dev/stdout", .{ .mode = .write_only });
    defer stdout_handle.close();


    // Read all input
    const input = try stdin_handle.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(input);

    var i: usize = 0;
    while (i < input.len) {
        const line_start = i;
        while (i < input.len and input[i] != '\n') {
            i += 1;
        }
        const line = input[line_start..i];

        var stack: [4096]u8 = undefined;
        var stack_len: usize = 0;
        var is_balanced = true;

        for (line) |char| {
            if (char == '(' or char == '[' or char == '{') {
                if (stack_len < stack.len) {
                    stack[stack_len] = char;
                    stack_len += 1;
                }
            } else if (char == ')') {
                if (stack_len == 0 or stack[stack_len - 1] != '(') {
                    is_balanced = false;
                    break;
                }
                stack_len -= 1;
            } else if (char == ']') {
                if (stack_len == 0 or stack[stack_len - 1] != '[') {
                    is_balanced = false;
                    break;
                }
                stack_len -= 1;
            } else if (char == '}') {
                if (stack_len == 0 or stack[stack_len - 1] != '{') {
                    is_balanced = false;
                    break;
                }
                stack_len -= 1;
            }
        }

        if (is_balanced and stack_len == 0) {
            _ = try stdout_handle.writeAll("yes\n");
        } else {
            _ = try stdout_handle.writeAll("no\n");
        }

        if (i < input.len and input[i] == '\n') {
            i += 1;
        }
    }
}
