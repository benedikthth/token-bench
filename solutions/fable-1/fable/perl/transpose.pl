use strict;
use warnings;

my $first = <STDIN>;
defined $first or exit 0;
my ($R, $C) = split ' ', $first;

my @rows;
for my $i (0 .. $R - 1) {
    my $line = <STDIN>;
    $line = '' unless defined $line;
    my @vals = split ' ', $line;
    push @rows, \@vals;
}

my @out;
for my $j (0 .. $C - 1) {
    push @out, join(' ', map { $rows[$_][$j] } 0 .. $R - 1);
}
print join("\n", @out), "\n" if @out;
