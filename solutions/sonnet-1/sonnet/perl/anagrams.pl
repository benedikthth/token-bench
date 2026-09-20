use strict;
use warnings;

my %groups;

while (my $line = <STDIN>) {
    chomp $line;
    next if $line eq '';
    my $key = join '', sort split //, $line;
    push @{ $groups{$key} }, $line;
}

my @out;
for my $key (keys %groups) {
    my @words = sort @{ $groups{$key} };
    push @out, \@words;
}

@out = sort { $a->[0] cmp $b->[0] } @out;

for my $group (@out) {
    print join(' ', @$group), "\n";
}
