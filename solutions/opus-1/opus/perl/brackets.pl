use strict;
use warnings;

my %pair = (')' => '(', ']' => '[', '}' => '{');
while (my $line = <STDIN>) {
    $line =~ s/[\r\n]+$//;
    my @stack;
    my $ok = 1;
    for my $c (split //, $line) {
        if (exists $pair{$c}) {
            if (!@stack || pop(@stack) ne $pair{$c}) { $ok = 0; last; }
        } elsif ($c =~ /[(\[{]/) {
            push @stack, $c;
        }
    }
    $ok = 0 if @stack;
    print $ok ? "yes\n" : "no\n";
}
