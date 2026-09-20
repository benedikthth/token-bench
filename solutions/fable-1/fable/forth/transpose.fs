\ Transpose an R x C integer matrix read from stdin.

variable r-count
variable c-count
variable mat            \ address of cell array (R*C cells)

1048576 constant bufsize
create linebuf bufsize allot
variable line-len
variable line-pos

\ Read a line from stdin into linebuf; false at EOF.
: read-next-line ( -- flag )
  linebuf bufsize stdin read-line throw   \ len flag
  swap line-len ! 0 line-pos ! ;

: cur ( -- c ) linebuf line-pos @ + c@ ;
: at-end? ( -- f ) line-pos @ line-len @ >= ;
: advance line-pos @ 1+ line-pos ! ;

\ Skip whitespace within current line and across lines.
: skip-ws ( -- ok )
  begin
    begin at-end? 0= while
      cur bl > if true exit then advance
    repeat
    read-next-line 0=
  until false ;

\ Read the next integer (handles leading '-'). Returns 0 at EOF.
: read-int ( -- n )
  skip-ws 0= if 0 exit then
  1                                        \ sign
  cur [char] - = if drop -1 advance then
  0                                        \ sign acc
  begin
    at-end? 0= cur [char] 0 >= and cur [char] 9 <= and
  while
    10 * cur [char] 0 - + advance
  repeat
  * ;

: at ( row col -- addr )  swap c-count @ * + cells mat @ + ;

: main
  0 line-len ! 0 line-pos !
  read-int r-count !
  read-int c-count !
  r-count @ c-count @ * 1 max cells allocate throw mat !
  r-count @ 0 ?do
    c-count @ 0 ?do
      read-int j i at !
    loop
  loop
  c-count @ 0 ?do
    r-count @ 0 ?do
      i j at @ 0 .r
      i r-count @ 1- < if space then
    loop
    cr
  loop ;

main
