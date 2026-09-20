const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var buf: [20]u8 = undefined;
    const bytes_read = try std.posix.read(0, &buf);
    const line = std.mem.trim(u8, buf[0..bytes_read], "\r\n");
    const n = try std.fmt.parseInt(u32, line, 10);

    if (n < 2) {
        _ = try std.posix.write(1, "\n");
        return;
    }

    // Sieve of Eratosthenes
    var is_prime = try allocator.alloc(bool, n + 1);
    defer allocator.free(is_prime);

    for (0..n + 1) |i| {
        is_prime[i] = true;
    }

    is_prime[0] = false;
    is_prime[1] = false;

    var i: u32 = 2;
    while (i * i <= n) : (i += 1) {
        if (is_prime[i]) {
            var j = i * i;
            while (j <= n) : (j += i) {
                is_prime[j] = false;
            }
        }
    }

    // Build output string
    var output = try allocator.alloc(u8, 1000000);
    defer allocator.free(output);

    var pos: usize = 0;
    var first = true;
    for (2..n + 1) |num| {
        if (is_prime[num]) {
            if (!first) {
                output[pos] = ' ';
                pos += 1;
            }
            const num_str = try std.fmt.allocPrint(allocator, "{}", .{num});
            defer allocator.free(num_str);
            std.mem.copyForwards(u8, output[pos..], num_str);
            pos += num_str.len;
            first = false;
        }
    }
    output[pos] = '\n';
    pos += 1;

    _ = try std.posix.write(1, output[0..pos]);
}
