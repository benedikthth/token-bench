\ Anagram groups

16777216 constant MAXBYTES
1000000  constant MAXWORDS
65536    constant LINEMAX

variable buf      variable keybuf   variable linebuf
variable wstart   variable wlen
variable idx      variable tmpa
variable gstart   variable gcnt     variable gtmp   variable gord
variable bufptr   variable nwords   variable ngroups

: alloc ( u -- addr ) allocate throw ;

MAXBYTES alloc buf !
MAXBYTES alloc keybuf !
LINEMAX  alloc linebuf !
MAXWORDS cells alloc wstart !
MAXWORDS cells alloc wlen !
MAXWORDS cells alloc idx !
MAXWORDS cells alloc tmpa !
MAXWORDS cells alloc gstart !
MAXWORDS cells alloc gcnt !
MAXWORDS cells alloc gtmp !
MAXWORDS cells alloc gord !
0 bufptr ! 0 nwords ! 0 ngroups !

: arr@ ( arr i -- x ) cells + @ ;
: arr! ( x arr i -- ) cells + ! ;

: word@ ( i -- addr u ) dup wstart @ swap arr@ buf @ +    swap wlen @ swap arr@ ;
: key@  ( i -- addr u ) dup wstart @ swap arr@ keybuf @ + swap wlen @ swap arr@ ;

\ ---------- input ----------
: trim ( addr u -- addr u )
  begin dup 0> if 2dup + 1- c@ bl <= else false then while 1- repeat
  begin dup 0> if over c@ bl <= else false then while 1 /string repeat ;

: add-word ( addr u -- )
  nwords @ MAXWORDS >= abort" too many words"
  bufptr @ over + MAXBYTES > abort" input too large"
  dup wlen @ nwords @ arr!
  bufptr @ wstart @ nwords @ arr!
  tuck buf @ bufptr @ + swap move
  bufptr +!
  1 nwords +! ;

: read-input
  begin linebuf @ LINEMAX stdin read-line throw while
    linebuf @ swap trim dup if add-word else 2drop then
  repeat drop ;

\ ---------- keys ----------
create counts 256 cells allot

: make-key ( i -- )
  counts 256 cells erase
  dup word@ over + swap ?do i c@ cells counts + 1 swap +! loop
  key@ drop
  256 0 do counts i cells + @ 0 ?do j over c! 1+ loop loop drop ;

: make-keys nwords @ 0 ?do i make-key loop ;

\ ---------- merge sort ----------
variable src  variable dst  variable 'cmp

: merge 0 0 0 { lo mid hi i j k }
  lo to i  mid to j  lo to k
  begin i mid < j hi < and while
    src @ i arr@ src @ j arr@ 'cmp @ execute 0<= if
      src @ i arr@ dst @ k arr!  i 1+ to i
    else
      src @ j arr@ dst @ k arr!  j 1+ to j
    then
    k 1+ to k
  repeat
  begin i mid < while src @ i arr@ dst @ k arr! i 1+ to i k 1+ to k repeat
  begin j hi < while src @ j arr@ dst @ k arr! j 1+ to j k 1+ to k repeat ;

: msort ( arr tmp n xt -- )
  'cmp ! 0 0 0 0 { arr tmp n w lo mid hi }
  arr src ! tmp dst !
  1 to w
  begin w n < while
    0 to lo
    begin lo n < while
      lo w + n min to mid
      lo w 2* + n min to hi
      lo mid hi merge
      lo w 2* + to lo
    repeat
    src @ dst @ src ! dst !
    w 2* to w
  repeat
  src @ arr <> if src @ arr n cells move then ;

\ ---------- comparators ----------
: cmp-kw ( i j -- n )
  2dup key@ rot key@ 2swap compare
  ?dup if -rot 2drop else swap word@ rot word@ compare then ;

: gword@ ( g -- addr u ) gstart @ swap arr@ idx @ swap arr@ word@ ;
: cmp-g ( g h -- n ) swap gword@ rot gword@ compare ;

\ ---------- grouping ----------
: build-groups
  0 ngroups !
  nwords @ 0 ?do
    i 0= if true else idx @ i arr@ key@ idx @ i 1- arr@ key@ compare 0<> then
    if
      i gstart @ ngroups @ arr!  1 gcnt @ ngroups @ arr!  1 ngroups +!
    else
      1 gcnt @ ngroups @ 1- cells + +!
    then
  loop ;

variable g
: print-groups
  ngroups @ 0 ?do
    gord @ i arr@ g !
    gstart @ g @ arr@ dup gcnt @ g @ arr@ + swap ?do
      i gstart @ g @ arr@ <> if space then
      idx @ i arr@ word@ type
    loop cr
  loop ;

: main
  read-input
  make-keys
  nwords @ 0 ?do i idx @ i arr! loop
  idx @ tmpa @ nwords @ ['] cmp-kw msort
  build-groups
  ngroups @ 0 ?do i gord @ i arr! loop
  gord @ gtmp @ ngroups @ ['] cmp-g msort
  print-groups ;

main
