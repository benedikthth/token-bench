\ Anagram groups

2000 constant maxn
64   constant maxlen

create wordbuf maxn maxlen * allot
create keybuf  maxn maxlen * allot
create wlenarr maxn cells allot
create idxarr  maxn cells allot
create gsarr   maxn cells allot
create gearr   maxn cells allot
create gidxarr maxn cells allot
create cnt     26 cells allot

variable n
variable gcount
variable curi
variable kpos

: word-addr ( i -- addr ) maxlen * wordbuf + ;
: key-addr  ( i -- addr ) maxlen * keybuf + ;
: wlen!     ( u i -- ) cells wlenarr + ! ;
: wlen@     ( i -- u ) cells wlenarr + @ ;

: word-of ( i -- addr len ) dup word-addr swap wlen@ ;
: key-of  ( i -- addr len ) dup key-addr  swap wlen@ ;

: idx@ ( pos -- v ) cells idxarr + @ ;
: idx! ( v pos -- ) cells idxarr + ! ;

: gs! ( pos g -- ) cells gsarr + ! ;
: ge! ( pos g -- ) cells gearr + ! ;
: gs@ ( g -- pos ) cells gsarr + @ ;
: ge@ ( g -- pos ) cells gearr + @ ;

: gidx@ ( pos -- g ) cells gidxarr + @ ;
: gidx! ( g pos -- ) cells gidxarr + ! ;

: read-all-words
  0 n !
  begin
    n @ word-addr maxlen stdin read-line throw
    ( u2 flag )
    0= if drop exit then
    dup 0> if
      n @ wlen!
      n @ 1+ n !
    else
      drop
    then
  again
;

: make-key ( i -- )
  curi !
  cnt 26 cells 0 fill
  curi @ wlen@ 0 ?do
    curi @ word-addr i + c@ [char] a - cells cnt + dup @ 1+ swap !
  loop
  0 kpos !
  26 0 do
    cnt i cells + @
    0 ?do
      curi @ key-addr kpos @ + [char] a j + swap c!
      1 kpos +!
    loop
  loop
;

: samekey? { ia ib -- flag }
  ia key-of { aa al }
  ib key-of { ba bl }
  aa al ba bl compare 0=
;

: cmp-idx { ia ib -- r }
  ia key-of { aa al }
  ib key-of { ba bl }
  aa al ba bl compare
  dup 0<> if exit then
  drop
  ia word-of { waa wal }
  ib word-of { wba wbl }
  waa wal wba wbl compare
;

: idx-swap { p1 p2 }
  p1 idx@ { t }
  p2 idx@ p1 idx!
  t p2 idx!
;

: partition { lo hi -- p }
  hi idx@ { pivot }
  lo { store }
  hi lo do
    i idx@ pivot cmp-idx 0< if
      store i idx-swap
      store 1+ to store
    then
  loop
  store hi idx-swap
  store
;

: qsort-idx { lo hi }
  lo hi < if
    lo hi partition { p }
    lo p 1- recurse
    p 1+ hi recurse
  then
;

: build-groups
  0 gcount !
  n @ 0> if
    0 0 gs!
    n @ 1 ?do
      i 1- idx@ i idx@ samekey? 0= if
        i 1- gcount @ ge!
        gcount @ 1+ gcount !
        i gcount @ gs!
      then
    loop
    n @ 1- gcount @ ge!
    gcount @ 1+ gcount !
  then
;

: init-gidx
  gcount @ 0 ?do i i gidx! loop
;

: group-word-of ( g -- addr len ) gs@ idx@ word-of ;

: cmp-group { ga gb -- r }
  ga group-word-of { aa al }
  gb group-word-of { ba bl }
  aa al ba bl compare
;

: gidx-swap { p1 p2 }
  p1 gidx@ { t }
  p2 gidx@ p1 gidx!
  t p2 gidx!
;

: gpartition { lo hi -- p }
  hi gidx@ { pivot }
  lo { store }
  hi lo do
    i gidx@ pivot cmp-group 0< if
      store i gidx-swap
      store 1+ to store
    then
  loop
  store hi gidx-swap
  store
;

: gqsort { lo hi }
  lo hi < if
    lo hi gpartition { p }
    lo p 1- recurse
    p 1+ hi recurse
  then
;

: print-group { g }
  g gs@ { s }
  g ge@ { e }
  e 1+ s do
    i idx@ word-of type
    i e < if space then
  loop
  cr
;

: output-groups
  gcount @ 0 ?do
    i gidx@ print-group
  loop
;

: main
  read-all-words
  n @ 0 ?do i make-key loop
  n @ 0 ?do i i idx! loop
  n @ 0> if 0 n @ 1- qsort-idx then
  build-groups
  init-gidx
  gcount @ 0> if 0 gcount @ 1- gqsort then
  output-groups
;

main
