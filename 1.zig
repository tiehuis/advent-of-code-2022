const std = @import("std");

var slurp_buf: [8 * 1024 * 1024]u8 = undefined;
pub fn slurp(filename: []const u8) ![]const u8 {
    const file = try std.fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();

    const len = try file.readAll(&slurp_buf);
    return slurp_buf[0..len];
}

// Contains a set of `max` items. New items can be quickly added and compared against existing
// items in the set.
pub fn MaxSet(comptime T: type, comptime max: usize) type {
    return struct {
        const Self = @This();
        values: [max]T = undefined,

        pub fn new() Self {
            return .{
                .values = [_]T{0} ** max,
            };
        }

        // Returns true if an existing max-entry was supplanted.
        pub fn add(self: *Self, n: T) bool {
            inline for (self.values) |_, i_| {
                const i = max - i_ - 1;
                const t = self.values[i];
                if (n >= t) {
                    comptime var y: usize = 0;
                    inline while (y < i) : (y += 1) {
                        self.values[y] = self.values[y + 1];
                    }
                    self.values[i] = n;
                    return true;
                }
            }
            return false;
        }

        pub fn sum(self: Self) T {
            var s: T = 0;
            for (self.values) |t| {
                s += t;
            }
            return s;
        }
    };
}

pub fn greatestSum(comptime max_n: usize, data: []const u8) !usize {
    var max = MaxSet(usize, max_n).new();
    var cur = @as(usize, 0);

    var tokens = std.mem.split(u8, data, "\n");
    while (tokens.next()) |t| {
        if (t.len == 0) {
            _ = max.add(cur);
            cur = 0;
        } else {
            cur += try std.fmt.parseUnsigned(usize, t, 10);
        }
    }
    _ = max.add(cur);
    return max.sum();
}

pub fn main() !void {
    const data = try slurp("input/1.txt");

    std.debug.print("Part 1: {}\n", .{try greatestSum(1, data)});
    std.debug.print("Part 2: {}\n", .{try greatestSum(3, data)});
}

const testcase =
    \\1000
    \\2000
    \\3000
    \\
    \\4000
    \\
    \\5000
    \\6000
    \\
    \\7000
    \\8000
    \\9000
    \\
    \\10000
;

test "1: Part One" {
    try std.testing.expectEqual(try greatestSum(1, testcase), 24_000);
}

test "1: Part Two" {
    try std.testing.expectEqual(try greatestSum(3, testcase), 45_000);
}
