use strict;
use warnings;

my $text = do { local $/; <STDIN> };
$text = '' unless defined $text;

my %count;
while ($text =~ /([A-Za-z]+)/g) {
    $count{lc($1)}++;
}

for my $word (sort { $count{$b} <=> $count{$a} or $a cmp $b } keys %count) {
    print "$word $count{$word}\n";
}
