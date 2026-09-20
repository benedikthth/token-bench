use strict;
use warnings;

my %groups;
while (my $line = <STDIN>) {
    $line =~ s/\s+//g;
    next if $line eq '';
    my $key = join '', sort split //, $line;
    push @{ $groups{$key} }, $line;
}

my @out = map { [ sort @$_ ] } values %groups;
for my $g (sort { $a->[0] cmp $b->[0] } @out) {
    print join(' ', @$g), "\n";
}
