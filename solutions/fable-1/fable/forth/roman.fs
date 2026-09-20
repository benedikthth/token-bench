\ Roman numerals: read integers from stdin, print roman numeral per line.

create vals 1000 , 900 , 500 , 400 , 100 , 90 , 50 , 40 , 10 , 9 , 5 , 4 , 1 ,
create syms 2 c, char M c, 0 c,
            2 c, char C c, char M c,
            2 c, char D c, 0 c,
            2 c, char C c, char D c,
            2 c, char C c, 0 c,
            2 c, char X c, char C c,
            2 c, char L c, 0 c,
            2 c, char X c, char L c,
            2 c, char X c, 0 c,
            2 c, char I c, char X c,
            2 c, char V c, 0 c,
            2 c, char I c, char V c,
            2 c, char I c, 0 c,

: sym-emit ( i -- )
    3 * syms + 1+ dup c@ emit 1+ c@ dup if emit else drop then ;

: roman ( n -- )
    13 0 do
        begin dup vals i cells + @ >= while
            vals i cells + @ - i sym-emit
        repeat
    loop drop ;

: parse-line ( addr len -- n flag )
    0 0 2swap >number 2drop d>s
    dup 0> ;

create linebuf 256 allot

: main
    begin
        linebuf 255 stdin read-line throw
    while
        linebuf swap parse-line
        if roman cr else drop then
    repeat drop ;

main
