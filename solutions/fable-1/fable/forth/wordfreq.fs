\ Word frequency counter

16777216 constant BUFSZ
4194304 constant HSIZE
HSIZE 1- constant HMASK
2097152 constant MAXENT

variable inbuf   BUFSZ allocate throw inbuf !
variable inlen   0 inlen !
variable pool    BUFSZ allocate throw pool !
variable poolused 0 poolused !
variable entries MAXENT 3 * cells allocate throw entries !
variable nentries 0 nentries !
variable htab    HSIZE cells allocate throw htab !
htab @ HSIZE cells erase

: read-all ( -- )
  begin
    inbuf @ inlen @ + BUFSZ inlen @ - stdin read-file throw
    dup 0= if drop exit then
    inlen +!
  again ;

: entry ( i -- a ) 3 * cells entries @ + ;
: slot ( h -- a ) cells htab @ + ;
: ecount ( i -- n ) entry 2 cells + @ ;
: eword ( i -- a l ) entry dup @ swap cell+ @ ;

: hash ( addr len -- h ) 0 -rot bounds ?do 31 * i c@ + loop ;

: find-slot ( addr len -- slotaddr )
  2dup hash
  begin
    HMASK and dup slot @            ( addr len h e )
    dup 0= if drop slot nip nip exit then
    1- eword                         ( addr len h ea el )
    4 pick 4 pick compare 0= if slot nip nip exit then
    1+
  again ;

: add-word ( addr len -- )
  2dup find-slot dup @ ?dup if      ( addr len slot e )
    nip nip nip 1- entry 2 cells + 1 swap +! exit then
  ( addr len slot )
  nentries @ 1+ over !
  drop
  nentries @ entry >r
  1 nentries +!
  pool @ poolused @ +               ( addr len dst )
  dup r@ !  over r@ cell+ !  1 r> 2 cells + !
  over poolused +!
  swap cmove ;

: letter? ( c -- f )
  dup [char] a [char] z 1+ within swap [char] A [char] Z 1+ within or ;
: lower ( c -- c ) dup [char] A [char] Z 1+ within if 32 + then ;

variable p
: scan ( -- )
  inbuf @ p !
  inbuf @ inlen @ +                 ( end )
  begin p @ over < while
    p @ c@ letter? if
      p @                           ( end start )
      begin p @ 2 pick < if p @ c@ letter? else false then while
        p @ c@ lower p @ c! 1 p +!
      repeat
      p @ over - add-word
    else 1 p +! then
  repeat drop ;

: before? ( i j -- f )
  2dup ecount swap ecount           ( i j cj ci )
  2dup = if 2drop swap eword rot eword compare 0<
  else < nip nip then ;

: eswap ( i j -- )
  entry swap entry                  ( aj ai )
  3 0 do
    over i cells + @ over i cells + @   ( aj ai vj vi )
    3 pick i cells + !
    over i cells + !
  loop 2drop ;

: qsort ( lo hi -- )
  2dup < if
    2dup + 2/ over eswap            ( lo hi )  \ pivot at hi
    over                            ( lo hi store )
    1 pick 3 pick ?do
      i 2 pick before? if i over eswap 1+ then
    loop
    over over eswap                 ( lo hi store )
    dup 1- 3 roll swap recurse      ( hi store )
    1+ swap recurse
  else 2drop then ;

: emit-all ( -- )
  nentries @ 0 ?do i eword type space i ecount 0 .r cr loop ;

: main ( -- )
  read-all scan
  nentries @ 0> if 0 nentries @ 1- qsort then
  emit-all ;
main
