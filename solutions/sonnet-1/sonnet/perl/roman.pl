use strict;
use warnings;

my @values = (1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1);
my @symbols = qw(M CM D CD C XC L XL X IX V IV I);

while (my $line = <STDIN>) {
    chomp $line;
    next unless $line =~ /\S/;
    my $n = $line + 0;
    my $result = '';
    for my $i (0 .. $#values) {
        while ($n >= $values[$i]) {
            $n -= $values[$i];
            $result .= $symbols[$i];
        }
    }
    print "$result\n";
}
