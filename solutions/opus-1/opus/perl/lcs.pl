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
my $m = scalar @y;

my @prev = (0) x ($m + 1);
for my $c (@x) {
    my @cur = (0);
    my $left = 0;
    for my $j (1 .. $m) {
        my $v;
        if ($y[$j - 1] eq $c) {
            $v = $prev[$j - 1] + 1;
        } else {
            my $up = $prev[$j];
            $v = $up > $left ? $up : $left;
        }
        push @cur, $v;
        $left = $v;
    }
    @prev = @cur;
}
print $prev[$m], "\n";
