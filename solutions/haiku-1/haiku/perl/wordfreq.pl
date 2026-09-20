#!/usr/bin/perl
use strict;
use warnings;

my %words;

while (<>) {
    # Extract all maximal runs of ASCII letters
    while (/([a-zA-Z]+)/g) {
        my $word = lc($1);
        $words{$word}++;
    }
}

# Sort by count descending, then by word ascending
my @sorted = sort {
    $words{$b} <=> $words{$a}  # Count descending
    ||
    $a cmp $b                    # Word ascending
} keys %words;

# Output
foreach my $word (@sorted) {
    print "$word $words{$word}\n";
}
