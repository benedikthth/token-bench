use strict;
use warnings;

my @tok;
my $pos;

sub parse_expr {
    my $v = parse_term();
    while ($pos < @tok && ($tok[$pos] eq '+' || $tok[$pos] eq '-')) {
        my $op = $tok[$pos++];
        my $r  = parse_term();
        $v = $op eq '+' ? $v + $r : $v - $r;
    }
    return $v;
}

sub parse_term {
    my $v = parse_factor();
    while ($pos < @tok && ($tok[$pos] eq '*' || $tok[$pos] eq '/')) {
        my $op = $tok[$pos++];
        my $r  = parse_factor();
        if ($op eq '*') {
            $v = $v * $r;
        } else {
            my $q = int(abs($v) / abs($r));
            $q = -$q if ($v < 0) != ($r < 0);
            $v = $q;
        }
    }
    return $v;
}

sub parse_factor {
    my $t = $tok[$pos++];
    if (!defined $t) { return 0; }
    if ($t eq '(') {
        my $v = parse_expr();
        $pos++ if $pos < @tok && $tok[$pos] eq ')';
        return $v;
    }
    return $t + 0;
}

while (my $line = <STDIN>) {
    $line =~ s/[\r\n]+$//;
    next if $line =~ /^\s*$/;
    @tok = ($line =~ /(\d+|[-+*\/()])/g);
    $pos = 0;
    my $v = parse_expr();
    print "$v\n";
}
