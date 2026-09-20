const std = @import("std");

const Entry = struct {
    word: []const u8,
    count: usize,
};

fn isLetter(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z');
}

fn toLower(c: u8) u8 {
    if (c >= 'A' and c <= 'Z') {
        return c + 32;
    }
    return c;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read all input - read in chunks
    var buffer = try allocator.alloc(u8, 1024 * 1024);
    defer allocator.free(buffer);

    var bytes_read: usize = 0;
    var temp: [4096]u8 = undefined;
    while (true) {
        const n = std.posix.read(0, temp[0..]) catch break;
        if (n == 0) break;
        @memcpy(buffer[bytes_read..][0..n], temp[0..n]);
        bytes_read += n;
    }

    const input = buffer[0..bytes_read];

    // Count words
    var word_map = std.StringHashMap(usize).init(allocator);
    defer {
        var iter = word_map.keyIterator();
        while (iter.next()) |key| {
            allocator.free(key.*);
        }
        word_map.deinit();
    }

    // Extract and count words
    var i: usize = 0;
    while (i < input.len) {
        // Skip non-letters
        while (i < input.len and !isLetter(input[i])) {
            i += 1;
        }

        // Read word
        const word_start = i;
        while (i < input.len and isLetter(input[i])) {
            i += 1;
        }

        if (word_start < i) {
            // We have a word
            const word_len = i - word_start;
            const word_buf = try allocator.alloc(u8, word_len);

            // Convert to lowercase
            for (word_buf, 0..) |*c, idx| {
                c.* = toLower(input[word_start + idx]);
            }

            const word_slice: []const u8 = word_buf;

            // Check if already in map
            if (word_map.getPtr(word_slice)) |count_ptr| {
                // Already exists, increment and free the duplicate
                count_ptr.* += 1;
                allocator.free(word_buf);
            } else {
                // New word, insert with count 1
                try word_map.put(word_slice, 1);
            }
        }
    }

    // Convert to array for sorting
    const num_words = word_map.count();
    var words = try allocator.alloc(Entry, num_words);
    defer allocator.free(words);

    var idx: usize = 0;
    var iter = word_map.iterator();
    while (iter.next()) |entry| {
        words[idx] = Entry{ .word = entry.key_ptr.*, .count = entry.value_ptr.* };
        idx += 1;
    }

    // Sort: count descending, then word ascending
    std.mem.sort(Entry, words, {}, struct {
        fn lessThan(_: void, a: Entry, b: Entry) bool {
            if (a.count != b.count) {
                return a.count > b.count;
            }
            return std.mem.lessThan(u8, a.word, b.word);
        }
    }.lessThan);

    // Output
    for (words) |entry| {
        var line_buf: [512]u8 = undefined;
        const line_len = std.fmt.bufPrint(&line_buf, "{s} {}\n", .{ entry.word, entry.count }) catch unreachable;
        _ = std.posix.write(1, line_len) catch unreachable;
    }
}
