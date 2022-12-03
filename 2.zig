const std = @import("std");

const ScoreFunc = fn (u8, u8) usize;

// Score a round assuming the following:
// a/0 = Rock, a/1 = Paper, a/2 = Scissors
// b/0 = Rock, b/1 = Paper, b/2 = Scissors
fn decrypt1(a: u8, b: u8) usize {
    return if (a == b)
        3 + b + 1
    else if ((a + 1) % 3 == b)
        6 + b + 1
    else
        b + 1;
}
// Score a round assuming the following:
// a/0 = Rock, a/1 = Paper, a/2 = Scissors
// b/0 = Lose, b/1 = Draw,  b/2 = Win
fn decrypt2(a: u8, b: u8) usize {
    const s = (b >> 1) | @as(u8, 2) * @boolToInt(b == 0);
    return 3 * b + ((a + s) % 3) + 1;
}

fn solve(comptime func: ScoreFunc, data: []const u8) usize {
    var sum: usize = 0;
    var tokens = std.mem.tokenize(u8, data, "\n");
    while (tokens.next()) |t| {
        sum += func(t[0] - 'A', t[2] - 'X');
    }
    return sum;
}

pub fn main() !void {
    const data = @embedFile("input/2.txt");

    std.debug.print("Part 1: {}\n", .{solve(decrypt1, data)});
    std.debug.print("Part 2: {}\n", .{solve(decrypt2, data)});
}

const testcase =
    \\A Y
    \\B X
    \\C Z
;

test "2: Part One" {
    try std.testing.expectEqual(solve(decrypt1, testcase), 15);
}

test "2: Part Two" {
    try std.testing.expectEqual(solve(decrypt2, testcase), 12);
}
