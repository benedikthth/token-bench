\ Transpose: read R C then R*C integers, print C rows of R integers.

1048576 constant bufsize
variable buf  bufsize allocate throw buf !
variable pos
variable len
variable nrows
variable ncols
variable mat

: read-ln ( -- flag )
  buf @ bufsize stdin read-line throw swap len ! 0 pos ! ;

: cur ( -- c ) buf @ pos @ + c@ ;

: skip-ws ( -- )
  begin
    pos @ len @ >= if read-ln 0= if exit then then
    pos @ len @ < if cur bl <= else false then
  while 1 pos +! repeat ;

: is-digit ( c -- f ) [char] 0 [char] 9 1+ within ;

: next-int ( -- n )
  skip-ws
  false
  pos @ len @ < if cur [char] - = if 0= 1 pos +! then then
  0
  begin pos @ len @ < dup if drop cur is-digit then
  while 10 * cur [char] 0 - + 1 pos +! repeat
  swap if negate then ;

: cell-at ( r c -- addr ) swap ncols @ * + cells mat @ + ;

: main
  next-int nrows ! next-int ncols !
  nrows @ ncols @ * 1 max cells allocate throw mat !
  nrows @ 0 ?do ncols @ 0 ?do next-int j i cell-at ! loop loop
  ncols @ 0 ?do
    nrows @ 0 ?do
      i j cell-at @ 0 .r
      i nrows @ 1- < if space then
    loop cr
  loop ;

main
