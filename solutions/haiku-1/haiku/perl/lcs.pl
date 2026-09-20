#!/usr/bin/perl
use strict;
use warnings;

my $s1 = <STDIN>;
my $s2 = <STDIN>;

chomp($s1);
chomp($s2);

my $len1 = length($s1);
my $len2 = length($s2);

# Create DP table
my @dp = map { [map { 0 } 0 .. $len2] } 0 .. $len1;

# Fill DP table
for my $i (1 .. $len1) {
    for my $j (1 .. $len2) {
        if (substr($s1, $i - 1, 1) eq substr($s2, $j - 1, 1)) {
            $dp[$i][$j] = $dp[$i - 1][$j - 1] + 1;
        } else {
            $dp[$i][$j] = ($dp[$i - 1][$j] > $dp[$i][$j - 1]) ? $dp[$i - 1][$j] : $dp[$i][$j - 1];
        }
    }
}

print $dp[$len1][$len2] . "\n";
