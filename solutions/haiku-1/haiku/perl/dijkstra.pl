#!/usr/bin/perl
use strict;
use warnings;

# Read N and M
my ($N, $M) = split(' ', <STDIN>);

# Build adjacency list
my %graph;
for my $i (0 .. $N - 1) {
    $graph{$i} = [];
}

# Read edges
for (1 .. $M) {
    my ($u, $v, $w) = split(' ', <STDIN>);
    push @{$graph{$u}}, [$v, $w];
    push @{$graph{$v}}, [$u, $w];
}

# Read s and t
my ($s, $t) = split(' ', <STDIN>);

# Special case: s == t
if ($s == $t) {
    print "0\n";
    exit;
}

# Dijkstra's algorithm
my @dist = (1e9) x $N;
$dist[$s] = 0;

my %visited;

# N iterations to relax all edges
for (1 .. $N) {
    # Find unvisited node with minimum distance
    my $u = -1;
    my $minDist = 1e9;

    for my $i (0 .. $N - 1) {
        if (!$visited{$i} && $dist[$i] < $minDist) {
            $minDist = $dist[$i];
            $u = $i;
        }
    }

    # No more reachable nodes
    last if $u == -1 || $minDist == 1e9;

    $visited{$u} = 1;

    # Relax edges from u
    for my $edge (@{$graph{$u}}) {
        my ($v, $w) = @$edge;
        if ($dist[$u] + $w < $dist[$v]) {
            $dist[$v] = $dist[$u] + $w;
        }
    }
}

# Output result
if ($dist[$t] == 1e9) {
    print "-1\n";
} else {
    print $dist[$t] . "\n";
}
