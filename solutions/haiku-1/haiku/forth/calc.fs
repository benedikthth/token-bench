1024 allocate drop constant mybuf

: test
    ." Reading line..." cr
    mybuf 256 stdin read-line
    ." Stack top (flag): " dup . cr
    ." Stack second (u2): " over . cr
    if
        ." EOF reached" cr
    else
        ." Line read, length: " . cr
    then
;

test
