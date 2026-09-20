const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var buf: [2100]u8 = undefined;

    // Read first line
    const n_total = try std.posix.read(0, &buf);

    // Find the first newline
    var first_nl: usize = 0;
    while (first_nl < n_total and buf[first_nl] != '\n') {
        first_nl += 1;
    }

    var line1 = buf[0..first_nl];
    if (std.mem.endsWith(u8, line1, "\r")) {
        line1 = line1[0 .. line1.len - 1];
    }

    // Find the second newline
    var second_nl: usize = first_nl + 1;
    while (second_nl < n_total and buf[second_nl] != '\n') {
        second_nl += 1;
    }

    var line2 = buf[first_nl + 1 .. second_nl];
    if (std.mem.endsWith(u8, line2, "\r")) {
        line2 = line2[0 .. line2.len - 1];
    }

    // Calculate LCS length
    const m = line1.len;
    const n = line2.len;

    // Allocate DP table
    var dp = try allocator.alloc([]usize, m + 1);
    for (0..m+1) |i| {
        dp[i] = try allocator.alloc(usize, n + 1);
    }

    defer {
        for (0..m+1) |i| {
            allocator.free(dp[i]);
        }
        allocator.free(dp);
    }

    // Initialize and fill DP table
    for (0..m+1) |i| {
        for (0..n+1) |j| {
            if (i == 0 or j == 0) {
                dp[i][j] = 0;
            } else if (line1[i-1] == line2[j-1]) {
                dp[i][j] = dp[i-1][j-1] + 1;
            } else {
                dp[i][j] = @max(dp[i-1][j], dp[i][j-1]);
            }
        }
    }

    // Output result
    var buf_out: [32]u8 = undefined;
    const result = try std.fmt.bufPrint(&buf_out, "{}\n", .{dp[m][n]});
    _ = try std.posix.write(1, result);
}
