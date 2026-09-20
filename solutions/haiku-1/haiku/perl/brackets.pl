#!/usr/bin/perl
use strict;
use warnings;

while (my $line = <>) {
    chomp($line);

    my @stack;
    my $valid = 1;
    my %closing = ('(' => ')', '[' => ']', '{' => '}');

    for my $char (split //, $line) {
        if ($char =~ /[(\[{]/) {
            # Opening bracket - push to stack
            push @stack, $char;
        } elsif ($char =~ /[)\]}]/) {
            # Closing bracket
            if (!@stack) {
                # No matching opening bracket
                $valid = 0;
                last;
            }

            my $open = pop @stack;

            # Check if closing bracket matches opening bracket
            if ($closing{$open} ne $char) {
                $valid = 0;
                last;
            }
        }
    }

    # Valid only if no errors and stack is empty
    if ($valid && !@stack) {
        print "yes\n";
    } else {
        print "no\n";
    }
}
