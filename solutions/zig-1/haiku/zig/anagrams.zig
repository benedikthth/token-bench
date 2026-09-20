const std = @import("std");

fn lessThanString(context: void, a: []const u8, b: []const u8) bool {
    _ = context;
    return std.mem.lessThan(u8, a, b);
}

fn lessThanU8(context: void, a: u8, b: u8) bool {
    _ = context;
    return a < b;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Create file objects for stdin and stdout
    const stdin_handle = 0;
    const stdout_handle = 1;

    var stdin_file = std.fs.File{ .handle = stdin_handle };
    var stdout_file = std.fs.File{ .handle = stdout_handle };

    // Read all lines
    var lines: [10000][]const u8 = undefined;
    var line_count: usize = 0;

    var read_buffer: [1024]u8 = undefined;
    var reader = stdin_file.reader(read_buffer);
    var buffer: [1024]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        const trimmed = std.mem.trim(u8, line, " \t\r");
        if (trimmed.len == 0) continue;
        lines[line_count] = try allocator.dupe(u8, trimmed);
        line_count += 1;
    }

    // Group by canonical form
    var group_keys: [10000][]const u8 = undefined;
    var group_count: usize = 0;

    for (lines[0..line_count]) |word| {
        // Create canonical form
        const sorted_chars = try allocator.alloc(u8, word.len);
        @memcpy(sorted_chars, word);
        std.mem.sort(u8, sorted_chars, {}, lessThanU8);

        // Find or create group
        var found: bool = false;
        var idx: usize = 0;
        while (idx < group_count) {
            if (std.mem.eql(u8, group_keys[idx], sorted_chars)) {
                found = true;
                allocator.free(sorted_chars);
                break;
            }
            idx += 1;
        }

        if (!found) {
            group_keys[group_count] = sorted_chars;
            group_count += 1;
        }
    }

    // Build groups with actual words
    var group_words: [10000][100][]const u8 = undefined;
    var group_word_counts: [10000]usize = undefined;
    var group_word_counters: [10000]usize = undefined;
    @memset(&group_word_counts, 0);
    @memset(&group_word_counters, 0);

    // Initialize word counts
    for (lines[0..line_count]) |word| {
        const sorted_chars = try allocator.alloc(u8, word.len);
        @memcpy(sorted_chars, word);
        std.mem.sort(u8, sorted_chars, {}, lessThanU8);

        var idx: usize = 0;
        while (idx < group_count) {
            if (std.mem.eql(u8, group_keys[idx], sorted_chars)) {
                group_word_counts[idx] += 1;
                break;
            }
            idx += 1;
        }
        allocator.free(sorted_chars);
    }

    // Add words to groups
    for (lines[0..line_count]) |word| {
        const sorted_chars = try allocator.alloc(u8, word.len);
        @memcpy(sorted_chars, word);
        std.mem.sort(u8, sorted_chars, {}, lessThanU8);

        var idx: usize = 0;
        while (idx < group_count) {
            if (std.mem.eql(u8, group_keys[idx], sorted_chars)) {
                group_words[idx][group_word_counters[idx]] = word;
                group_word_counters[idx] += 1;
                break;
            }
            idx += 1;
        }
        allocator.free(sorted_chars);
    }

    // Sort words within each group
    var i: usize = 0;
    while (i < group_count) {
        std.mem.sort([]const u8, group_words[i][0..group_word_counts[i]], {}, lessThanString);
        i += 1;
    }

    // Create sorted group order
    var group_order: [10000]usize = undefined;
    i = 0;
    while (i < group_count) {
        group_order[i] = i;
        i += 1;
    }

    // Sort groups by first word
    const group_indices = group_order[0..group_count];
    std.mem.sort(usize, group_indices, &group_words, groupCompareFn);

    // Output groups
    var write_buffer: [4096]u8 = undefined;
    var writer = stdout_file.writer(write_buffer);

    i = 0;
    while (i < group_count) {
        const group_idx = group_indices[i];
        const words = group_words[group_idx][0..group_word_counts[group_idx]];
        var j: usize = 0;
        while (j < words.len) {
            if (j > 0) try writer.writeAll(" ");
            try writer.writeAll(words[j]);
            j += 1;
        }
        try writer.writeAll("\n");
        i += 1;
    }

    // Cleanup
    i = 0;
    while (i < line_count) {
        allocator.free(lines[i]);
        i += 1;
    }
    i = 0;
    while (i < group_count) {
        allocator.free(group_keys[i]);
        i += 1;
    }
}

fn groupCompareFn(context: *[10000][100][]const u8, a: usize, b: usize) bool {
    const groups = context;
    if (groups[a].len == 0 or groups[b].len == 0) return false;
    return std.mem.lessThan(u8, groups[a][0], groups[b][0]);
}
