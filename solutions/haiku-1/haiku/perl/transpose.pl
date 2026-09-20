#!/usr/bin/perl
use strict;
use warnings;

my ($R, $C) = split / /, <>;

my @matrix;
for (1..$R) {
    my $line = <>;
    chomp($line);
    my @row = split / /, $line;
    push @matrix, \@row;
}

# Transpose
for my $j (0..$C-1) {
    my @transposed_row = map { $matrix[$_][$j] } 0..$R-1;
    print join(" ", @transposed_row) . "\n";
}
