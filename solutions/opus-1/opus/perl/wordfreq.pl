use strict;
use warnings;

my %c;
while (my $line = <STDIN>) {
    $c{lc $1}++ while $line =~ /([A-Za-z]+)/g;
}
print "$_ $c{$_}\n" for sort { $c{$b} <=> $c{$a} || $a cmp $b } keys %c;
