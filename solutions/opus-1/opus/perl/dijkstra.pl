use strict;
use warnings;

local $/;
my $in = <STDIN>;
my @t = split ' ', $in;
my $p = 0;
my ($n, $m) = @t[$p, $p + 1]; $p += 2;
my @adj = map { [] } 0 .. $n - 1;
for (1 .. $m) {
    my ($u, $v, $w) = @t[$p .. $p + 2]; $p += 3;
    push @{ $adj[$u] }, $v, $w;
    push @{ $adj[$v] }, $u, $w;
}
my ($s, $e) = @t[$p, $p + 1];

if ($s == $e) { print "0\n"; exit; }

my @dist;
$dist[$s] = 0;
my @hd = (0);
my @hn = ($s);

while (@hd) {
    my $d = $hd[0];
    my $u = $hn[0];
    my $ld = pop @hd;
    my $ln = pop @hn;
    if (@hd) {
        my $i = 0;
        my $sz = @hd;
        while (1) {
            my $c = 2 * $i + 1;
            last if $c >= $sz;
            $c++ if $c + 1 < $sz && $hd[$c + 1] < $hd[$c];
            last if $hd[$c] >= $ld;
            $hd[$i] = $hd[$c];
            $hn[$i] = $hn[$c];
            $i = $c;
        }
        $hd[$i] = $ld;
        $hn[$i] = $ln;
    }
    next if $d > $dist[$u];
    if ($u == $e) { print "$d\n"; exit; }
    my $a = $adj[$u];
    for (my $k = 0; $k < @$a; $k += 2) {
        my $v  = $a->[$k];
        my $nd = $d + $a->[$k + 1];
        if (!defined $dist[$v] || $nd < $dist[$v]) {
            $dist[$v] = $nd;
            my $i = @hd;
            while ($i > 0) {
                my $pi = ($i - 1) >> 1;
                last if $hd[$pi] <= $nd;
                $hd[$i] = $hd[$pi];
                $hn[$i] = $hn[$pi];
                $i = $pi;
            }
            $hd[$i] = $nd;
            $hn[$i] = $v;
        }
    }
}
print "-1\n";
