variable buf  variable blen  variable pos
: ch ( -- c ) buf @ pos @ + c@ ;
: more? ( -- f ) pos @ blen @ < ;
: digit? ( c -- f ) [char] 0 - 10 u< ;
: skip begin more? if ch digit? 0= else 0 then while 1 pos +! repeat ;
: num ( -- n )
  skip 0 begin more? if ch digit? else 0 then
  while 10 * ch [char] 0 - + 1 pos +! repeat ;

variable n  variable m
variable head  variable eto  variable ew  variable enext  variable ecnt
variable dist  variable hd  variable hn  variable hcnt

: arr ( n -- addr ) 1 max cells allocate throw ;
: at ( i var -- addr ) @ swap cells + ;

: addedge { u v w -- }
  ecnt @ { e }
  v e eto at !  w e ew at !
  u head at @ e enext at !  e u head at !
  1 ecnt +! ;
: read-edge num num num { u v w } u v w addedge v u w addedge ;

: hkey ( i -- d ) hd at @ ;
: hswap { i j -- }
  i hd at @ j hd at @ i hd at ! j hd at !
  i hn at @ j hn at @ i hn at ! j hn at ! ;
: parent ( i -- p ) 1- 2/ ;
: push { d v -- }
  hcnt @ { i }
  d i hd at !  v i hn at !  1 hcnt +!
  begin i 0> if i parent hkey i hkey > else 0 then
  while i parent i hswap i parent to i repeat ;
: pop ( -- d v )
  0 hkey 0 hn at @
  -1 hcnt +!
  hcnt @ hkey 0 hd at !  hcnt @ hn at @ 0 hn at !
  0 { i }
  begin
    i 2* 1+ dup hcnt @ <
  while
    dup 1+ hcnt @ < if dup 1+ hkey over hkey < if 1+ then then
    dup hkey i hkey <
  while
    dup i hswap to i
  repeat then drop ;

: relax { d e -- }
  e eto at @ { x }
  d e ew at @ + { nd }
  x dist at @ dup 0< swap nd > or if nd x dist at ! nd x push then ;
: step
  pop { d v }
  d v dist at @ = if
    v head at @ begin dup 0>= while d over relax enext at @ repeat drop
  then ;

: main
  stdin slurp-fid blen ! buf ! 0 pos !
  num n ! num m !
  n @ arr head !  n @ arr dist !
  n @ 0 ?do -1 i head at ! -1 i dist at ! loop
  m @ 2* dup arr eto ! dup arr ew ! arr enext !  0 ecnt !
  m @ 2* 2 + dup arr hd ! arr hn !  0 hcnt !
  m @ 0 ?do read-edge loop
  num num { s t }
  0 s dist at !  0 s push
  begin hcnt @ while step repeat
  t dist at @ 0 .r cr ;
main
