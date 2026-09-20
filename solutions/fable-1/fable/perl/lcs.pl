use strict;
use warnings;

my $a = <STDIN>;
my $b = <STDIN>;
$a = '' unless defined $a;
$b = '' unless defined $b;
$a =~ s/[\r\n]+$//;
$b =~ s/[\r\n]+$//;

my @x = split //, $a;
my @y = split //, $b;
my $n = scalar @x;
my $m = scalar @y;

my @prev = (0) x ($m + 1);
my @cur  = (0) x ($m + 1);

for my $i (1 .. $n) {
    my $ci = $x[$i - 1];
    $cur[0] = 0;
    for my $j (1 .. $m) {
        if ($ci eq $y[$j - 1]) {
            $cur[$j] = $prev[$j - 1] + 1;
        } else {
            $cur[$j] = $prev[$j] >= $cur[$j - 1] ? $prev[$j] : $cur[$j - 1];
        }
    }
    @prev = @cur;
}

print $prev[$m], "\n";
