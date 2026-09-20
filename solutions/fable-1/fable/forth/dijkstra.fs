\ Shortest path (Dijkstra with binary heap)

1 60 lshift constant INF

\ ---------- input ----------
4096 constant BUFSZ
create linebuf BUFSZ allot
variable lineptr  variable linelen
0 lineptr !  0 linelen !

: refill-line ( -- flag )
  linebuf BUFSZ stdin read-line throw
  if linelen ! 0 lineptr ! true else drop false then ;

: skip-ws ( -- )
  begin lineptr @ linelen @ < while
    linebuf lineptr @ + c@ bl > if exit then
    1 lineptr +!
  repeat ;

: next-token ( -- addr len )
  begin
    skip-ws
    lineptr @ linelen @ < if
      linebuf lineptr @ + 0
      begin lineptr @ linelen @ <
            linebuf lineptr @ + c@ bl > and while
        1+ 1 lineptr +!
      repeat exit
    then
    refill-line 0= if 0 0 exit then
  again ;

: read-int ( -- n )
  next-token dup 0= if 2drop 0 exit then
  over c@ [char] - = if 1 /string -1 else 1 then >r
  0 0 2swap >number 2drop drop r> * ;

\ ---------- graph ----------
variable N  variable M
variable head  variable nxt  variable eto  variable ewt  variable dist
variable ecnt

: alloc-cells ( n -- addr ) cells allocate throw ;

: add-edge ( u v w -- )
  ecnt @ >r
  r@ cells ewt @ + !
  r@ cells eto @ + !
  cells head @ + dup @ r@ cells nxt @ + ! r> swap !
  1 ecnt +! ;

\ ---------- heap ----------
variable hk  variable hv  variable hsize
: hkey ( i -- addr ) cells hk @ + ;
: hval ( i -- addr ) cells hv @ + ;
: xchg ( a1 a2 -- ) 2dup @ swap @ rot ! swap ! ;
: hswap ( i j -- ) 2dup hkey swap hkey xchg  hval swap hval xchg ;

: sift-up ( i -- )
  begin dup 0> while
    dup 1- 2/
    over hkey @ over hkey @ < 0= if 2drop exit then
    tuck hswap
  repeat drop ;

: sift-down ( i -- )
  begin
    dup 2* 1+ dup hsize @ < 0= if 2drop exit then
    dup 1+ dup hsize @ < if
      dup hkey @ 2 pick hkey @ < if nip else drop then
    else drop then
    over hkey @ over hkey @ > 0= if 2drop exit then
    tuck hswap
  again ;

: hpush ( key val -- )
  hsize @ >r  r@ hval ! r@ hkey !  1 hsize +!  r> sift-up ;

: hpop ( -- key val )
  0 hkey @ 0 hval @
  -1 hsize +!
  hsize @ hkey @ 0 hkey !  hsize @ hval @ 0 hval !
  0 sift-down ;

\ ---------- dijkstra ----------
: dijkstra ( s t -- n )
  N @ 0 ?do INF i cells dist @ + ! loop
  0 hsize !
  over cells dist @ + 0 swap !
  0 rot hpush
  begin hsize @ 0> while
    hpop                                   ( t d u )
    dup cells dist @ + @ 2 pick = if
      dup 3 pick = if drop nip exit then
      cells head @ + @                     ( t d e )
      begin dup 0 >= while
        dup cells eto @ + @  over cells ewt @ + @   ( t d e v w )
        3 pick +                           ( t d e v nd )
        over cells dist @ + @ over > if
          2dup swap cells dist @ + !  swap hpush
        else 2drop then
        cells nxt @ + @
      repeat drop drop
    else 2drop then
  repeat drop -1 ;

: main
  read-int N ! read-int M !
  N @ 1+ alloc-cells head !
  N @ 1+ alloc-cells dist !
  M @ 2* 2 + dup alloc-cells nxt ! dup alloc-cells eto ! dup alloc-cells ewt !
  dup alloc-cells hk ! alloc-cells hv !
  N @ 0 ?do -1 i cells head @ + ! loop
  0 ecnt !
  M @ 0 ?do
    read-int read-int read-int
    2 pick 2 pick 2 pick add-edge
    >r swap r> add-edge
  loop
  read-int read-int dijkstra 0 .r cr ;

main
