use strict;
use warnings;

my $s = <STDIN>;
$s = '' unless defined $s;
$s =~ s/[\r\n]+$//;
my $out = '';
while ($s =~ /(([a-z])\2*)/g) {
    $out .= $2 . length($1);
}
print "$out\n";
