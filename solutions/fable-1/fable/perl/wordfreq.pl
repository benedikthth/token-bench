use strict;
use warnings;

my %count;
while (my $line = <STDIN>) {
    while ($line =~ /([A-Za-z]+)/g) {
        $count{lc $1}++;
    }
}

for my $w (sort { $count{$b} <=> $count{$a} || $a cmp $b } keys %count) {
    print "$w $count{$w}\n";
}
