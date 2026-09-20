#!/usr/bin/perl
use strict;
use warnings;

my %groups;

# Read words and group by canonical form (sorted letters)
while (my $word = <STDIN>) {
    chomp $word;
    # Create canonical form by sorting letters
    my $canonical = join('', sort split //, $word);
    push @{$groups{$canonical}}, $word;
}

# Build output groups with sorted words
my @output;
for my $canonical (keys %groups) {
    my @sorted_words = sort @{$groups{$canonical}};
    push @output, \@sorted_words;
}

# Sort groups by their first word (alphabetically)
@output = sort { $a->[0] cmp $b->[0] } @output;

# Print each group
for my $group (@output) {
    print join(' ', @$group) . "\n";
}
