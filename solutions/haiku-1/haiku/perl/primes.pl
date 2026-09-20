#!/usr/bin/perl
use strict;
use warnings;

my $n = <STDIN>;
chomp($n);

if ($n < 2) {
    print "\n";
    exit;
}

# Sieve of Eratosthenes
my @is_prime;
for my $i (0..$n) {
    $is_prime[$i] = 1;
}
$is_prime[0] = 0;
$is_prime[1] = 0;

for my $i (2..int(sqrt($n))) {
    if ($is_prime[$i]) {
        for (my $j = $i*$i; $j <= $n; $j += $i) {
            $is_prime[$j] = 0;
        }
    }
}

my @primes;
for my $i (2..$n) {
    if ($is_prime[$i]) {
        push @primes, $i;
    }
}

print join(" ", @primes) . "\n";
