65536 constant maxlen
create buf maxlen allot
variable len
variable pos

: cur ( -- c ) pos @ len @ < if buf pos @ + c@ else 0 then ;
: skip ( -- ) begin cur 1 bl 1+ within while 1 pos +! repeat ;
: peekc ( -- c ) skip cur ;
: isdig ( c -- f ) [char] 0 - 10 u< ;
: tdiv ( a b -- q ) >r s>d r> sm/rem nip ;

defer expr

: number ( -- n )
  skip 0 begin cur isdig while 10 * cur [char] 0 - + 1 pos +! repeat ;

: factor ( -- n )
  peekc [char] ( = if
    1 pos +! expr peekc [char] ) = if 1 pos +! then
  else number then ;

: term ( -- n )
  factor
  begin peekc dup [char] * = over [char] / = or while
    1 pos +! factor swap [char] * = if * else tdiv then
  repeat drop ;

:noname ( -- n )
  term
  begin peekc dup [char] + = over [char] - = or while
    1 pos +! term swap [char] + = if + else - then
  repeat drop ; is expr

: main ( -- )
  begin buf maxlen stdin read-line throw while
    len ! 0 pos !
    peekc if expr 0 .r cr then
  repeat drop ;

main
