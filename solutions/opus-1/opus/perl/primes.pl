use strict;
use warnings;

my $input = do { local $/; <STDIN> };
my ($n) = defined $input ? $input =~ /(\d+)/ : ();
$n = 0 unless defined $n;

my @out;
if ($n >= 2) {
    my @composite = (0) x ($n + 1);
    for (my $i = 2; $i * $i <= $n; $i++) {
        next if $composite[$i];
        for (my $j = $i * $i; $j <= $n; $j += $i) {
            $composite[$j] = 1;
        }
    }
    @out = grep { !$composite[$_] } 2 .. $n;
}
print join(' ', @out), "\n";
