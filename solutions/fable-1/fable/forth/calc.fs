\ Expression calculator: recursive-descent parser over one line of input.

4096 constant maxlen
create buf maxlen allot
variable len
variable pos

: peek ( -- c )  pos @ len @ < if buf pos @ + c@ else 0 then ;
: advance ( -- )  1 pos +! ;
: ws? ( c -- f )  dup bl = swap dup 9 = swap 13 = or or ;
: skip-ws ( -- )  begin peek ws? while advance repeat ;
: isdigit ( c -- f )  dup [char] 0 >= swap [char] 9 <= and ;

: parse-num ( -- n )
  0 begin peek isdigit while 10 * peek [char] 0 - + advance repeat ;

\ truncating division
: tdiv ( n m -- q )  >r s>d r> sm/rem nip ;

defer expr

: factor ( -- n )
  skip-ws
  peek [char] ( = if
    advance expr skip-ws advance   \ consume ')'
  else
    parse-num
  then ;

: mulop? ( c -- f )  dup [char] * = swap [char] / = or ;
: addop? ( c -- f )  dup [char] + = swap [char] - = or ;

: term ( -- n )
  factor
  begin skip-ws peek mulop? while
    peek advance >r factor r>
    [char] * = if * else tdiv then
  repeat ;

: expr' ( -- n )
  term
  begin skip-ws peek addop? while
    peek advance >r term r>
    [char] + = if + else - then
  repeat ;
' expr' is expr

: blank-line? ( -- f )  0 pos ! skip-ws peek 0= ;

: main ( -- )
  begin buf maxlen stdin read-line throw while
    len !
    blank-line? 0= if 0 pos ! expr 0 .r cr then
  repeat drop ;

main
