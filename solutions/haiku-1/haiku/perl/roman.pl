#!/usr/bin/perl
use strict;
use warnings;

my @conversions = (
    [1000, 'M'],
    [900,  'CM'],
    [500,  'D'],
    [400,  'CD'],
    [100,  'C'],
    [90,   'XC'],
    [50,   'L'],
    [40,   'XL'],
    [10,   'X'],
    [9,    'IX'],
    [5,    'V'],
    [4,    'IV'],
    [1,    'I'],
);

while (my $num = <>) {
    chomp($num);
    my $roman = '';

    foreach my $pair (@conversions) {
        my ($value, $numeral) = @$pair;
        while ($num >= $value) {
            $roman .= $numeral;
            $num -= $value;
        }
    }

    print "$roman\n";
}
