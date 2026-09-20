use strict;
use warnings;

local $/;
my @t = split ' ', (<STDIN> // '');
my $r = shift @t // 0;
my $c = shift @t // 0;
my $out = '';
for my $j (0 .. $c - 1) {
    $out .= join(' ', map { $t[$_ * $c + $j] } 0 .. $r - 1) . "\n";
}
print $out;
