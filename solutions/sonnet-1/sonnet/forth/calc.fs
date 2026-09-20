\ Expression calculator: + - * / and parentheses, left-to-right, usual precedence.

VARIABLE buf-addr
VARIABLE buf-len
VARIABLE pos

: cur ( -- c ) pos @ buf-len @ >= IF 0 ELSE buf-addr @ pos @ + c@ THEN ;
: adv ( -- ) 1 pos +! ;
: skip-sp ( -- ) BEGIN cur bl = WHILE adv REPEAT ;
: digit? ( c -- f ) [char] 0 [char] 9 1+ within ;

: parse-num ( -- n )
  0
  BEGIN cur digit? WHILE
    10 * cur [char] 0 - + adv
  REPEAT ;

DEFER parse-expr

: parse-factor ( -- n )
  skip-sp
  cur [char] ( = IF
    adv parse-expr skip-sp adv
  ELSE
    parse-num
  THEN ;

\ truncated (toward zero) integer division
: t/ ( n1 n2 -- n3 ) >r s>d r> sm/rem nip ;

: parse-term ( -- n )
  parse-factor
  BEGIN
    skip-sp cur [char] * = cur [char] / = OR
  WHILE
    cur [char] * = IF adv parse-factor * ELSE adv parse-factor t/ THEN
  REPEAT ;

:noname ( -- n )
  parse-term
  BEGIN
    skip-sp cur [char] + = cur [char] - = OR
  WHILE
    cur [char] + = IF adv parse-term + ELSE adv parse-term - THEN
  REPEAT
; IS parse-expr

CREATE linebuf 256 allot

: get-line ( -- u flag ) linebuf 256 stdin read-line throw ;

: strip-cr ( u -- u2 )
  dup 0> IF
    dup 1- linebuf + c@ 13 = IF 1- THEN
  THEN ;

: .n ( n -- )
  dup >r abs s>d <# #s r> sign #> type ;

: process-line ( u -- )
  strip-cr
  dup 0= IF drop ELSE
    buf-len !
    linebuf buf-addr !
    0 pos !
    parse-expr .n cr
  THEN ;

: main
  BEGIN get-line WHILE
    process-line
  REPEAT
  drop ;

main
bye
