use strict;
use warnings;

my %pairs = (
    ')' => '(',
    ']' => '[',
    '}' => '{',
);

while (my $line = <STDIN>) {
    chomp $line;
    my @stack;
    my $ok = 1;
    for my $ch (split //, $line) {
        if ($ch eq '(' || $ch eq '[' || $ch eq '{') {
            push @stack, $ch;
        } elsif (exists $pairs{$ch}) {
            if (@stack && $stack[-1] eq $pairs{$ch}) {
                pop @stack;
            } else {
                $ok = 0;
                last;
            }
        }
    }
    $ok = 0 if @stack;
    print $ok ? "yes\n" : "no\n";
}
