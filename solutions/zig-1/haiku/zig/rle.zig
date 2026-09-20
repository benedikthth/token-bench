const std = @import("std");

pub fn main() !void {
    // Read from stdin using posix
    var line_buf: [1024]u8 = undefined;
    var line_len: usize = 0;

    // Read input byte by byte until newline
    var byte_buf: [1]u8 = undefined;
    while (line_len < line_buf.len) {
        const bytes_read = try std.posix.read(0, &byte_buf);
        if (bytes_read == 0 or byte_buf[0] == '\n') {
            break;
        }
        line_buf[line_len] = byte_buf[0];
        line_len += 1;
    }

    // Handle empty input
    if (line_len == 0) {
        return;
    }

    const line = line_buf[0..line_len];

    // Process run-length encoding
    var i: usize = 0;
    while (i < line.len) {
        const current_char = line[i];
        var count: usize = 1;

        // Count consecutive characters
        while (i + count < line.len and line[i + count] == current_char) {
            count += 1;
        }

        // Write character and its count
        var output: [20]u8 = undefined;
        const len = try std.fmt.bufPrint(&output, "{c}{d}", .{current_char, count});
        _ = try std.posix.write(1, len);

        i += count;
    }
}
