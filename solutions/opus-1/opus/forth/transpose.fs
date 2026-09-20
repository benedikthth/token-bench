variable pos  variable lim
variable rows  variable cols  variable mat

: ws? ( c -- f ) dup 32 = over 10 = or over 13 = or swap 9 = or ;

: skip-ws ( -- )
  begin pos @ lim @ < while pos @ c@ ws? while 1 pos +! repeat then ;

: read-int ( -- n )
  skip-ws
  1 pos @ lim @ < if pos @ c@ [char] - = if drop -1 1 pos +! then then
  0 begin pos @ lim @ < while
    pos @ c@ dup [char] 0 >= over [char] 9 <= and while
    [char] 0 - swap 10 * + 1 pos +!
  repeat drop then
  * ;

: main
  stdin slurp-fid over + lim ! pos !
  read-int rows !  read-int cols !
  rows @ cols @ * 1 max cells allocate throw mat !
  rows @ cols @ * 0 ?do read-int mat @ i cells + ! loop
  cols @ 0 ?do
    rows @ 0 ?do
      i 0> if space then
      mat @ i cols @ * j + cells + @ 0 .r
    loop
    cr
  loop ;

main
