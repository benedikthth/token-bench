use strict;
use warnings;

my $line = <STDIN>;
$line = '' unless defined $line;
$line =~ s/\r?\n\z//;

my $out = '';
while ($line =~ /(([a-z])\2*)/g) {
    $out .= $2 . length($1);
}
print "$out\n";
