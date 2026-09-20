use strict;
use warnings;
use integer;

my (@t, $p);

sub expr {
    my $v = term();
    while ($p < @t && ($t[$p] eq '+' || $t[$p] eq '-')) {
        my $op = $t[$p++];
        my $r = term();
        $v = $op eq '+' ? $v + $r : $v - $r;
    }
    return $v;
}

sub term {
    my $v = factor();
    while ($p < @t && ($t[$p] eq '*' || $t[$p] eq '/')) {
        my $op = $t[$p++];
        my $r = factor();
        if ($op eq '*') {
            $v = $v * $r;
        } else {
            my $q = abs($v) / abs($r);
            $v = (($v < 0) != ($r < 0)) ? -$q : $q;
        }
    }
    return $v;
}

sub factor {
    my $tok = $t[$p++];
    if ($tok eq '(') {
        my $v = expr();
        $p++;
        return $v;
    }
    return 0 + $tok;
}

while (my $line = <STDIN>) {
    @t = $line =~ /(\d+|[-+*\/()])/g;
    next unless @t;
    $p = 0;
    print expr(), "\n";
}
