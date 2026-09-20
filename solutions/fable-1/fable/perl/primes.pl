use strict;
use warnings;

my $line = <STDIN>;
$line = '' unless defined $line;
my ($n) = $line =~ /(-?\d+)/;
$n = 0 unless defined $n;

my @primes;
if ($n >= 2) {
    my @composite = (0) x ($n + 1);
    for my $i (2 .. $n) {
        next if $composite[$i];
        push @primes, $i;
        for (my $j = $i * $i; $j <= $n; $j += $i) {
            $composite[$j] = 1;
        }
    }
}

print join(' ', @primes), "\n";
