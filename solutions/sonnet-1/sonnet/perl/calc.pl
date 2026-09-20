use strict;
use warnings;

my ($str, $pos);

sub skip_ws {
    while ($pos < length($str) && substr($str, $pos, 1) eq ' ') {
        $pos++;
    }
}

sub parse_expr {
    my $val = parse_term();
    skip_ws();
    while ($pos < length($str) && (substr($str, $pos, 1) eq '+' || substr($str, $pos, 1) eq '-')) {
        my $op = substr($str, $pos, 1);
        $pos++;
        my $rhs = parse_term();
        if ($op eq '+') {
            $val += $rhs;
        } else {
            $val -= $rhs;
        }
        skip_ws();
    }
    return $val;
}

sub parse_term {
    my $val = parse_factor();
    skip_ws();
    while ($pos < length($str) && (substr($str, $pos, 1) eq '*' || substr($str, $pos, 1) eq '/')) {
        my $op = substr($str, $pos, 1);
        $pos++;
        my $rhs = parse_factor();
        if ($op eq '*') {
            $val *= $rhs;
        } else {
            my $q = $val / $rhs;
            $q = $q >= 0 ? int($q) : -int(-$q);
            $val = $q;
        }
        skip_ws();
    }
    return $val;
}

sub parse_factor {
    skip_ws();
    if (substr($str, $pos, 1) eq '(') {
        $pos++;
        my $val = parse_expr();
        skip_ws();
        if ($pos < length($str) && substr($str, $pos, 1) eq ')') {
            $pos++;
        }
        return $val;
    } else {
        skip_ws();
        my $start = $pos;
        while ($pos < length($str) && substr($str, $pos, 1) =~ /[0-9]/) {
            $pos++;
        }
        my $num = substr($str, $start, $pos - $start);
        return $num + 0;
    }
}

while (my $line = <STDIN>) {
    chomp $line;
    next if $line =~ /^\s*$/;
    $str = $line;
    $pos = 0;
    my $result = parse_expr();
    print "$result\n";
}
