use strict;
use warnings;

my @lines = <STDIN>;
chomp @lines;

my ($n, $m) = split ' ', shift @lines;

my @adj;
for my $i (0 .. $n - 1) {
    $adj[$i] = [];
}

for my $i (1 .. $m) {
    my $line = shift @lines;
    my ($u, $v, $w) = split ' ', $line;
    push @{ $adj[$u] }, [$v, $w];
    push @{ $adj[$v] }, [$u, $w];
}

my ($s, $t) = split ' ', shift @lines;

if ($s == $t) {
    print "0\n";
    exit;
}

my @dist = (undef) x $n;
$dist[$s] = 0;

my @visited = (0) x $n;

for (1 .. $n) {
    my $u = -1;
    my $best;
    for my $i (0 .. $n - 1) {
        next if $visited[$i];
        next unless defined $dist[$i];
        if (!defined $best || $dist[$i] < $best) {
            $best = $dist[$i];
            $u = $i;
        }
    }
    last if $u == -1;
    $visited[$u] = 1;
    last if $u == $t;

    for my $edge (@{ $adj[$u] }) {
        my ($v, $w) = @$edge;
        next if $visited[$v];
        my $nd = $dist[$u] + $w;
        if (!defined $dist[$v] || $nd < $dist[$v]) {
            $dist[$v] = $nd;
        }
    }
}

if (defined $dist[$t]) {
    print "$dist[$t]\n";
} else {
    print "-1\n";
}
