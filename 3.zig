const std = @import("std");

const Rucksack = std.bit_set.IntegerBitSet(53);

fn symval(x: u8) u8 {
    return switch (x) {
        'a'...'z' => x - 'a' + 1,
        'A'...'Z' => x - 'A' + 27,
        else => unreachable,
    };
}

fn solve1(data: []const u8) usize {
    var sum: usize = 0;

    var tokens = std.mem.tokenize(u8, data, "\n");
    while (tokens.next()) |t| {
        var s1 = Rucksack.initEmpty();
        var s2 = Rucksack.initEmpty();

        const mid = t.len / 2;
        for (t[0..mid]) |e| s1.set(symval(e));
        for (t[mid..]) |e| s2.set(symval(e));

        s1.setIntersection(s2);
        sum += s1.findFirstSet() orelse unreachable;
    }

    return sum;
}

fn solve2(data: []const u8) usize {
    var sum: usize = 0;

    var tokens = std.mem.tokenize(u8, data, "\n");
    outer: while (true) {
        var s = Rucksack.initFull();

        var i: usize = 0;
        while (i < 3) : (i += 1) {
            var s1 = Rucksack.initEmpty();
            const t1 = tokens.next() orelse break :outer;
            for (t1) |e| s1.set(symval(e));
            s.setIntersection(s1);
        }

        sum += s.findFirstSet() orelse unreachable;
    }

    return sum;
}

pub fn main() !void {
    const data = @embedFile("input/3.txt");

    std.debug.print("Part 1: {}\n", .{solve1(data)});
    std.debug.print("Part 2: {}\n", .{solve2(data)});
}

const testcase =
    \\vJrwpWtwJgWrhcsFMMfFFhFp
    \\jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    \\PmmdzqPrVvPwwTWBwg
    \\wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    \\ttgJtRGJQctTZtZT
    \\CrZsJsPPZsGzwwsLwLmpwMDw
;

test "3: Part One" {
    try std.testing.expectEqual(solve1(testcase), 157);
}

test "3: Part Two" {
    try std.testing.expectEqual(solve2(testcase), 70);
}
