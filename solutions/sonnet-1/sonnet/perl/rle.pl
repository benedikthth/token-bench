use strict;
use warnings;

my $line = <STDIN>;
$line = '' unless defined $line;
$line =~ s/[\r\n]+$//;

my $out = '';
while ($line =~ /(.)(\1*)/g) {
    my $len = 1 + length($2);
    $out .= "$1$len";
}

print "$out\n";
