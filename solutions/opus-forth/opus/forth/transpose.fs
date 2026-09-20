\ Transpose an R x C integer matrix read from stdin.

decimal

1048576 constant bufsize
create linebuf bufsize allot

variable llen
variable lpos
variable eofflag
variable negflag
variable rows
variable cols
variable mat

: white? ( c -- f )  dup bl = swap 9 = or ;

: refill-line ( -- )
  linebuf bufsize stdin read-line throw
  0= if eofflag on then
  llen ! 0 lpos ! ;

: at-end? ( -- f )  lpos @ llen @ >= ;

: cur ( -- c )  linebuf lpos @ + c@ ;

: skipws ( -- )
  begin
    begin at-end? 0= if cur white? else false then
    while 1 lpos +! repeat
    at-end? eofflag @ 0= and
  while refill-line repeat ;

: digit? ( c -- f )  dup [char] 0 >= swap [char] 9 <= and ;

: getnum ( -- n )
  skipws
  false negflag !
  at-end? 0= if
    cur [char] - = if negflag on 1 lpos +! then
  then
  0
  begin at-end? 0= if cur digit? else false then
  while 10 * cur [char] 0 - + 1 lpos +! repeat
  negflag @ if negate then ;

: cell-at ( r c -- addr )  swap cols @ * + cells mat @ + ;

: read-matrix ( -- )
  getnum rows ! getnum cols !
  rows @ cols @ * 1 max cells allocate throw mat !
  rows @ 0 ?do
    cols @ 0 ?do
      getnum j i cell-at !
    loop
  loop ;

: write-matrix ( -- )
  cols @ 0 ?do
    rows @ 0 ?do
      i 0> if space then
      i j cell-at @ 0 .r
    loop
    cr
  loop ;

: main ( -- )  read-matrix write-matrix ;

main
