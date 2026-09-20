\ Shortest path (Dijkstra) on an undirected weighted graph.

1000000000 constant INF
16777216 constant BUFSIZE  \ 16 MB input buffer

0 value nN
0 value mM
0 value sS
0 value tT
0 value mat
0 value dist
0 value visited

0 value inbuf
0 value inlen
0 value inpos

: cur-char ( -- c ) inbuf inpos + c@ ;

: read-all-input ( -- )
  BUFSIZE allocate throw to inbuf
  0 to inlen
  begin
    inbuf inlen + 4096 stdin read-line throw  ( u2 flag )
  while
    ( u2 ) inlen + to inlen
    bl inbuf inlen + c!
    inlen 1+ to inlen
  repeat
  drop
  0 to inpos ;

: skip-spaces ( -- )
  begin
    inpos inlen < if cur-char bl <= else false then
  while
    inpos 1+ to inpos
  repeat ;

: next-token ( -- c-addr u )
  skip-spaces
  inbuf inpos +
  begin
    inpos inlen < if cur-char bl > else false then
  while
    inpos 1+ to inpos
  repeat
  inbuf inpos + over - ;

: token>num ( -- n )
  next-token 0 0 2swap >number 2drop d>s ;

: midx ( i j -- addr ) nN * + cells mat + ;
: mat@ ( i j -- w ) midx @ ;
: mat! ( w i j -- ) midx ! ;

variable best-idx
variable best-val

: find-min ( -- )
  -1 best-idx !
  INF best-val !
  nN 0 do
    visited i cells + @ 0= if
      dist i cells + @ best-val @ < if
        dist i cells + @ best-val !
        i best-idx !
      then
    then
  loop ;

0 value curU
0 value curV

: relax ( v -- )
  to curV
  visited curV cells + @ 0= if
    curU curV mat@                 ( w )
    dup INF < if
      dist curU cells + @ +        ( newdist )
      dup dist curV cells + @ < if
        dist curV cells + !
      else
        drop
      then
    else
      drop
    then
  then ;

: relax-all ( u -- )
  to curU
  nN 0 do
    i relax
  loop ;

: dijkstra ( -- )
  nN 0 do
    find-min
    best-idx @ dup -1 = if drop leave then
    dup visited swap cells + 1 swap !
    relax-all
  loop ;

0 value edgeU
0 value edgeV
0 value edgeW

: main
  read-all-input
  token>num to nN
  token>num to mM
  nN nN * cells allocate throw to mat
  nN nN * 0 do INF mat i cells + ! loop
  mM 0 ?do
    token>num token>num token>num  ( u v w )
    to edgeW to edgeV to edgeU
    edgeW edgeU edgeV mat@ min edgeU edgeV mat!
    edgeW edgeV edgeU mat@ min edgeV edgeU mat!
  loop
  token>num to sS
  token>num to tT
  sS tT = if
    0 . cr
    exit
  then
  nN cells allocate throw to dist
  nN cells allocate throw to visited
  nN 0 do INF dist i cells + ! loop
  nN 0 do 0 visited i cells + ! loop
  0 dist sS cells + !
  dijkstra
  dist tT cells + @
  dup INF < if . else drop -1 . then
  cr ;

main
