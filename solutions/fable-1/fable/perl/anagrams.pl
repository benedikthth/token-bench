use strict;
use warnings;

my %groups;
while (my $line = <STDIN>) {
    $line =~ s/\r?\n\z//;
    next if $line eq '';
    my $key = join '', sort split //, $line;
    push @{ $groups{$key} }, $line;
}

my @out;
for my $key (keys %groups) {
    push @out, [ sort @{ $groups{$key} } ];
}

for my $g (sort { $a->[0] cmp $b->[0] } @out) {
    print join(' ', @$g), "\n";
}
