\ Debug: Test read-line stack
: main
    pad 100 stdin read-line
    .s cr
    ." Done" cr ;

main
