\ Anagram groups

2000000 constant maxw
64000000 constant tsize

tsize allocate throw constant text
maxw cells allocate throw constant wa
maxw cells allocate throw constant wl
maxw cells allocate throw constant ka
maxw cells allocate throw constant idx
maxw cells allocate throw constant gs
maxw cells allocate throw constant gord
variable tp  0 tp !
variable nw  0 nw !
variable ng  0 ng !
variable gap

: sortkey { a u -- }
  u 1 ?do
    i begin
      dup 0> if a over + 1- c@ a 2 pick + c@ > else false then
    while
      a over + 1- c@  a 2 pick + c@
      a 3 pick + 1- c!  a 2 pick + c!
      1-
    repeat drop
  loop ;

: cur ( -- a ) text tp @ + ;

: readall
  begin
    cur 65536 stdin read-line throw
  while
    dup 0> if cur over + 1- c@ 13 = if 1- then then
    dup 0> if
      cur nw @ cells wa + !
      dup nw @ cells wl + !
      cur over + nw @ cells ka + !
      cur dup 2 pick + 2 pick move
      cur over + over sortkey
      2* tp +!
      1 nw +!
    else drop then
  repeat drop ;

: key@ ( i -- a u ) dup cells ka + @ swap cells wl + @ ;
: word@ ( i -- a u ) dup cells wa + @ swap cells wl + @ ;

: cmp1 { i j -- n }
  i key@ j key@ compare ?dup 0= if i word@ j word@ compare then ;

: cmp2 { g h -- n }
  g cells gs + @ cells idx + @ word@
  h cells gs + @ cells idx + @ word@ compare ;

: shellsort { arr n xt -- }
  n gap !
  begin gap @ 1 > while
    gap @ dup 2 = if drop 1 else 5 11 */ then gap !
    n gap @ ?do
      i cells arr + @
      i
      begin
        dup gap @ >= if dup gap @ - cells arr + @ 2 pick xt execute 0> else false then
      while
        dup gap @ - cells arr + @ over cells arr + !
        gap @ -
      repeat
      cells arr + !
    loop
  repeat ;

: groups
  nw @ 0 ?do
    i 0= if true else
      i 1- cells idx + @ key@ i cells idx + @ key@ compare 0<>
    then
    if i ng @ cells gs + !  ng @ ng @ cells gord + !  1 ng +! then
  loop ;

: gend ( g -- e ) 1+ dup ng @ = if drop nw @ else cells gs + @ then ;

: output
  ng @ 0 ?do
    i cells gord + @
    dup gend swap cells gs + @
    dup cells idx + @ word@ type
    1+ ?do space i cells idx + @ word@ type loop
    cr
  loop ;

: main
  readall
  nw @ 0 ?do i i cells idx + ! loop
  idx nw @ ['] cmp1 shellsort
  groups
  gord ng @ ['] cmp2 shellsort
  output ;

main
