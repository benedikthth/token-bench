const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read all input manually
    var stdin_file = std.fs.File{ .handle = 0 };

    var all_input: [16384]u8 = undefined;
    var input_pos: usize = 0;

    // Read from stdin in chunks until EOF
    while (input_pos < all_input.len) {
        var read_buf: [1024]u8 = undefined;
        const bytes_read = try stdin_file.read(&read_buf);
        if (bytes_read == 0) break;
        for (read_buf[0..bytes_read]) |b| {
            all_input[input_pos] = b;
            input_pos += 1;
        }
    }

    // Parse the input
    var input_stream = std.io.fixedBufferStream(all_input[0..input_pos]);
    var reader = input_stream.reader();

    var line_buffer: [128]u8 = undefined;

    // Read first line with R and C
    const first_line = try reader.readUntilDelimiter(&line_buffer, '\n');
    var parts = std.mem.tokenizeSequence(u8, first_line, " ");
    const r_str = parts.next() orelse return;
    const c_str = parts.next() orelse return;
    const r = try std.fmt.parseInt(usize, r_str, 10);
    const c = try std.fmt.parseInt(usize, c_str, 10);

    // Read the matrix
    var matrix = try allocator.alloc([]i32, r);
    defer allocator.free(matrix);

    for (0..r) |i| {
        var matrix_line_buffer: [1024]u8 = undefined;
        const line = try reader.readUntilDelimiter(&matrix_line_buffer, '\n');
        matrix[i] = try allocator.alloc(i32, c);

        var line_parts = std.mem.tokenizeSequence(u8, line, " ");
        for (0..c) |j| {
            const num_str = line_parts.next() orelse return;
            matrix[i][j] = try std.fmt.parseInt(i32, num_str, 10);
        }
    }
    defer {
        for (matrix) |row| {
            allocator.free(row);
        }
        allocator.free(matrix);
    }

    // Output the transposed matrix
    var stdout_file = std.fs.File{ .handle = 1 };
    var write_buffer: [4096]u8 = undefined;
    var output_stream = std.io.fixedBufferStream(&write_buffer);
    var writer = output_stream.writer();

    for (0..c) |j| {
        for (0..r) |i| {
            if (i > 0) try writer.writeAll(" ");
            var num_buffer: [32]u8 = undefined;
            const num_str = try std.fmt.bufPrint(&num_buffer, "{}", .{matrix[i][j]});
            try writer.writeAll(num_str);
        }
        try writer.writeAll("\n");
    }

    const output = output_stream.getWritten();
    try stdout_file.writeAll(output);
}
