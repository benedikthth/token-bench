\ Balanced brackets checker

4096 constant maxline
create linebuf maxline allot
create stk maxline allot
variable sp

: push ( c -- ) stk sp @ + c! 1 sp +! ;
: pop ( -- c ) -1 sp +! stk sp @ + c@ ;

: opener? ( c -- f ) dup [char] ( = over [char] [ = or swap [char] { = or ;
: closer-of ( c -- c' ) \ opener -> matching closer
  dup [char] ( = if drop [char] ) exit then
  dup [char] [ = if drop [char] ] exit then
  drop [char] } ;

: balanced? ( addr u -- f )
  0 sp !
  0 ?do
    dup i + c@
    dup opener? if
      closer-of push
    else
      sp @ 0= if drop drop unloop false exit then
      pop <> if drop unloop false exit then
    then
  loop drop
  sp @ 0= ;

: strip-cr ( addr u -- addr u' )
  dup 0> if 2dup + 1- c@ 13 = if 1- then then ;

: main
  begin
    linebuf maxline stdin read-line throw
  while
    linebuf swap strip-cr balanced?
    if ." yes" else ." no" then cr
  repeat drop ;

main
