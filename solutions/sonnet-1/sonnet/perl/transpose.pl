use strict;
use warnings;

my $first = <STDIN>;
my ($r, $c) = split ' ', $first;

my @matrix;
for my $i (0 .. $r - 1) {
    my $line = <STDIN>;
    chomp $line;
    my @vals = split ' ', $line;
    push @matrix, \@vals;
}

for my $j (0 .. $c - 1) {
    my @col;
    for my $i (0 .. $r - 1) {
        push @col, $matrix[$i][$j];
    }
    print join(' ', @col), "\n";
}
