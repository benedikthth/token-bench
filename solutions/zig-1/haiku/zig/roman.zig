const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdin_file = try std.fs.openFileAbsolute("/dev/stdin", .{});
    defer stdin_file.close();

    const stdout_file = try std.fs.openFileAbsolute("/dev/stdout", .{.mode = .write_only});
    defer stdout_file.close();

    // Read all stdin
    const input = try stdin_file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(input);

    var lines = std.mem.splitSequence(u8, input, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const num = std.fmt.parseInt(u32, line, 10) catch continue;

        var result: [20]u8 = undefined;
        const roman = intToRoman(num, &result);

        _ = try stdout_file.writeAll(roman);
        _ = try stdout_file.writeAll("\n");
    }
}

fn intToRoman(num: u32, result: []u8) []u8 {
    const values = [_]u32{ 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1 };
    const numerals = [_][]const u8{ "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I" };

    var remaining = num;
    var pos: usize = 0;

    for (values, numerals) |value, numeral| {
        while (remaining >= value) {
            for (numeral) |ch| {
                result[pos] = ch;
                pos += 1;
            }
            remaining -= value;
        }
    }

    return result[0..pos];
}
