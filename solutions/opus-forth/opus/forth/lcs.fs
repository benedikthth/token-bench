\ Longest common subsequence of two input lines.

2048 constant MAXN

create buf1 MAXN chars allot
create buf2 MAXN chars allot
create rowa MAXN cells allot
create rowb MAXN cells allot

variable len1
variable len2
variable pv          \ previous row address
variable cu          \ current row address

: ]@ ( addr i -- n ) cells + @ ;
: ]! ( n addr i -- ) cells + ! ;

\ drop trailing control characters (CR, spaces) from a counted string
: rtrim ( c-addr u -- u )
  begin
    dup 0>
  while
    2dup 1- chars + c@ 32 > if nip exit then
    1-
  repeat
  nip ;

: read-line-into ( c-addr -- u )
  dup MAXN 1- stdin read-line throw drop rtrim ;

: lcs ( -- n )
  rowa MAXN cells erase
  rowb MAXN cells erase
  rowa pv !  rowb cu !
  len1 @ 0 ?do
    0 cu @ 0 ]!
    len2 @ 0 ?do
      buf1 j chars + c@  buf2 i chars + c@ = if
        pv @ i ]@ 1+
      else
        pv @ i 1+ ]@   cu @ i ]@   max
      then
      cu @ i 1+ ]!
    loop
    pv @ cu @ pv ! cu !
  loop
  pv @ len2 @ ]@ ;

: main ( -- )
  buf1 read-line-into len1 !
  buf2 read-line-into len2 !
  lcs . cr ;

main
