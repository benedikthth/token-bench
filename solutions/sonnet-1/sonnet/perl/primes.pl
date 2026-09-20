use strict;
use warnings;

my $n = <STDIN>;
$n = 0 unless defined $n;
$n =~ s/\D+//g;
$n = 0 if $n eq '';
$n = int($n);

my @is_composite = (0) x ($n + 1);
my @primes;

for (my $i = 2; $i <= $n; $i++) {
    next if $is_composite[$i];
    push @primes, $i;
    for (my $j = $i * $i; $j <= $n; $j += $i) {
        $is_composite[$j] = 1;
    }
}

print join(' ', @primes), "\n";
