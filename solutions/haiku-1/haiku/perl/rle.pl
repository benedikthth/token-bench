#!/usr/bin/perl
use strict;
use warnings;

my $line = <STDIN>;
chomp($line) if defined $line;
$line //= '';  # Default to empty string if undef

my $result = '';
my $current_char = '';
my $count = 0;

for my $char (split //, $line) {
    if ($char eq $current_char) {
        $count++;
    } else {
        if ($current_char ne '') {
            $result .= $current_char . $count;
        }
        $current_char = $char;
        $count = 1;
    }
}

# Don't forget the last run
if ($current_char ne '') {
    $result .= $current_char . $count;
}

print $result;
