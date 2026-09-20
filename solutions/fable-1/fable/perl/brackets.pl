use strict;
use warnings;

my %pair = (')' => '(', ']' => '[', '}' => '{');

while (my $line = <STDIN>) {
    $line =~ s/\r?\n\z//;
    my @stack;
    my $ok = 1;
    for my $c (split //, $line) {
        if ($c eq '(' || $c eq '[' || $c eq '{') {
            push @stack, $c;
        }
        elsif (exists $pair{$c}) {
            if (!@stack || pop(@stack) ne $pair{$c}) {
                $ok = 0;
                last;
            }
        }
        else {
            $ok = 0;
            last;
        }
    }
    $ok = 0 if @stack;
    print $ok ? "yes\n" : "no\n";
}
