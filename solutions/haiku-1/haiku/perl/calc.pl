#!/usr/bin/perl
use strict;
use warnings;

my $input;

sub parse_expression {
    my $result = parse_term();

    while ($input =~ /^\s*[\+\-]/s) {
        $input =~ s/^\s*(\+|\-)\s*//s;
        my $op = $1;
        my $right = parse_term();

        if ($op eq '+') {
            $result += $right;
        } else {
            $result -= $right;
        }
    }

    return $result;
}

sub parse_term {
    my $result = parse_factor();

    while ($input =~ /^\s*[\*\/]/s) {
        $input =~ s/^\s*(\*|\/)\s*//s;
        my $op = $1;
        my $right = parse_factor();

        if ($op eq '*') {
            $result *= $right;
        } else {
            # Integer division truncating toward zero
            $result = int($result / $right);
        }
    }

    return $result;
}

sub parse_factor {
    if ($input =~ s/^\s*\(\s*//s) {
        # Opening parenthesis: recursively parse the expression inside
        my $result = parse_expression();
        $input =~ s/^\s*\)//s;
        return $result;
    } else {
        # Number: extract a sequence of digits
        $input =~ s/^\s*(\d+)\s*//s;
        return $1;
    }
}

while (<STDIN>) {
    chomp;
    $input = $_;
    print parse_expression(), "\n";
}
