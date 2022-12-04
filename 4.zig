const std = @import("std");

inline fn fullyOverlaps(x: [2]u8, y: [2]u8) bool {
    return x[0] <= y[0] and x[1] >= y[1] or y[0] <= x[0] and y[1] >= x[1];
}

inline fn overlaps(x: [2]u8, y: [2]u8) bool {
    return x[0] <= y[1] and y[0] <= x[1];
}

fn solve(data: []const u8) [2]usize {
    var sum1: usize = 0;
    var sum2: usize = 0;

    var tokens = std.mem.tokenize(u8, data, "\n");
    while (tokens.next()) |t| {
        var s = [_]u8{0} ** 4;
        var i: usize = 0;

        for (t) |c| switch (c) {
            '0'...'9' => {
                s[i] *= 10;
                s[i] += c - '0';
            },
            else => i += 1,
        };

        sum1 += @boolToInt(fullyOverlaps(s[0..2].*, s[2..4].*));
        sum2 += @boolToInt(overlaps(s[0..2].*, s[2..4].*));
    }

    return .{ sum1, sum2 };
}

pub fn main() !void {
    const data = @embedFile("input/4.txt");

    const r = solve(data);
    std.debug.print("Part 1: {}\n", .{r[0]});
    std.debug.print("Part 2: {}\n", .{r[1]});
}

const testcase =
    \\2-4,6-8
    \\2-3,4-5
    \\5-7,7-9
    \\2-8,3-7
    \\6-6,4-6
    \\2-6,4-8
    \\
;

test "4: Part One" {
    try std.testing.expectEqual(solve(testcase)[0], 2);
}

test "4: Part Two" {
    try std.testing.expectEqual(solve(testcase)[1], 4);
}
