use strict;
use warnings;

my @map = ([1000,'M'],[900,'CM'],[500,'D'],[400,'CD'],[100,'C'],[90,'XC'],
           [50,'L'],[40,'XL'],[10,'X'],[9,'IX'],[5,'V'],[4,'IV'],[1,'I']);

while (my $line = <STDIN>) {
    next unless $line =~ /(\d+)/;
    my $n = $1;
    my $s = '';
    for my $p (@map) {
        while ($n >= $p->[0]) { $s .= $p->[1]; $n -= $p->[0]; }
    }
    print "$s\n";
}
