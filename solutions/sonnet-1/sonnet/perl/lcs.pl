use strict;
use warnings;

my $a = <STDIN>;
my $b = <STDIN>;
$a = '' unless defined $a;
$b = '' unless defined $b;
$a =~ s/[\r\n]+$//;
$b =~ s/[\r\n]+$//;

my $n = length($a);
my $m = length($b);

my @prev = (0) x ($m + 1);
my @cur  = (0) x ($m + 1);

for (my $i = 1; $i <= $n; $i++) {
    my $ca = substr($a, $i - 1, 1);
    for (my $j = 1; $j <= $m; $j++) {
        my $cb = substr($b, $j - 1, 1);
        if ($ca eq $cb) {
            $cur[$j] = $prev[$j - 1] + 1;
        } else {
            $cur[$j] = $prev[$j] > $cur[$j - 1] ? $prev[$j] : $cur[$j - 1];
        }
    }
    @prev = @cur;
}

print $prev[$m], "\n";
