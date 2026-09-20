use strict;
use warnings;

my @tokens;
{
    local $/;
    my $data = <STDIN>;
    $data = '' unless defined $data;
    @tokens = split ' ', $data;
}
my $idx = 0;
my $n = $tokens[$idx++] // 0;
my $m = $tokens[$idx++] // 0;

my @adj;
$adj[$_] = [] for 0 .. $n - 1;
for my $i (1 .. $m) {
    my $u = $tokens[$idx++];
    my $v = $tokens[$idx++];
    my $w = $tokens[$idx++];
    last unless defined $w;
    push @{ $adj[$u] }, [ $v, $w ];
    push @{ $adj[$v] }, [ $u, $w ];
}
my $s = $tokens[$idx++] // 0;
my $t = $tokens[$idx++] // 0;

if ($s == $t) {
    print "0\n";
    exit 0;
}

my @dist;
$dist[$s] = 0;

# Binary min-heap of [dist, node]
my @heap = ( [ 0, $s ] );

sub heap_push {
    my ($item) = @_;
    push @heap, $item;
    my $i = $#heap;
    while ( $i > 0 ) {
        my $p = ( $i - 1 ) >> 1;
        last if $heap[$p][0] <= $heap[$i][0];
        @heap[ $p, $i ] = @heap[ $i, $p ];
        $i = $p;
    }
}

sub heap_pop {
    my $top  = $heap[0];
    my $last = pop @heap;
    if (@heap) {
        $heap[0] = $last;
        my $i = 0;
        my $sz = scalar @heap;
        while (1) {
            my $l = 2 * $i + 1;
            last if $l >= $sz;
            my $r = $l + 1;
            my $c = ( $r < $sz && $heap[$r][0] < $heap[$l][0] ) ? $r : $l;
            last if $heap[$i][0] <= $heap[$c][0];
            @heap[ $i, $c ] = @heap[ $c, $i ];
            $i = $c;
        }
    }
    return $top;
}

my $answer = -1;
while (@heap) {
    my ( $d, $u ) = @{ heap_pop() };
    next if $d > $dist[$u];
    if ( $u == $t ) {
        $answer = $d;
        last;
    }
    for my $e ( @{ $adj[$u] } ) {
        my ( $v, $w ) = @$e;
        my $nd = $d + $w;
        if ( !defined $dist[$v] || $nd < $dist[$v] ) {
            $dist[$v] = $nd;
            heap_push( [ $nd, $v ] );
        }
    }
}

print "$answer\n";
