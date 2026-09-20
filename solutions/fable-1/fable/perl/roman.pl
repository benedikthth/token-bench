use strict;
use warnings;

my @map = (
    [1000, 'M'], [900, 'CM'], [500, 'D'], [400, 'CD'],
    [100, 'C'], [90, 'XC'], [50, 'L'], [40, 'XL'],
    [10, 'X'], [9, 'IX'], [5, 'V'], [4, 'IV'], [1, 'I'],
);

while (my $line = <STDIN>) {
    $line =~ s/^\s+|\s+$//g;
    next if $line eq '';
    my $n = int($line);
    my $out = '';
    for my $pair (@map) {
        my ($v, $s) = @$pair;
        while ($n >= $v) {
            $out .= $s;
            $n -= $v;
        }
    }
    print "$out\n";
}
