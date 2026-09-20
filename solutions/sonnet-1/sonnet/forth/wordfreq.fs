\ Word frequency counter

2000000 constant max-buf
create inbuf max-buf allot
variable inlen
0 inlen !

: read-all-input ( -- )
  begin
    inbuf inlen @ + max-buf inlen @ - stdin read-line throw
    swap inlen +!
    dup if
      inbuf inlen @ + bl swap c!
      1 inlen +!
    then
    0=
  until
;

: upper? ( c -- f ) 65 91 within ;
: lower? ( c -- f ) 97 123 within ;
: letter? ( c -- f ) dup upper? swap lower? or ;
: to-lower ( c -- c' ) dup upper? if 32 + then ;

100000 constant max-words
create w-addr max-words cells allot
create w-len  max-words cells allot
create w-cnt  max-words cells allot
variable n-words
0 n-words !

: w-addr@ ( idx -- val ) cells w-addr + @ ;
: w-len@  ( idx -- val ) cells w-len + @ ;
: w-cnt@  ( idx -- val ) cells w-cnt + @ ;
: w-addr! ( val idx -- ) cells w-addr + ! ;
: w-len!  ( val idx -- ) cells w-len + ! ;
: w-cnt!  ( val idx -- ) cells w-cnt + ! ;

variable found-idx

: find-word ( addr len -- idx )
  -1 found-idx !
  n-words @ 0 ?do
    2dup i w-addr@ i w-len@ compare 0= if
      i found-idx !
      leave
    then
  loop
  2drop
  found-idx @
;

: process-word { addr len -- }
  addr len find-word { idx }
  idx -1 = if
    addr n-words @ w-addr!
    len n-words @ w-len!
    1 n-words @ w-cnt!
    n-words @ 1+ n-words !
  else
    idx w-cnt@ 1+ idx w-cnt!
  then
;

variable pos
variable wstart

: scan-all-words ( -- )
  0 pos !
  begin
    pos @ inlen @ <
  while
    inbuf pos @ + c@ letter?
    if
      pos @ wstart !
      begin
        pos @ inlen @ < if inbuf pos @ + c@ letter? else false then
      while
        inbuf pos @ + dup c@ to-lower swap c!
        pos @ 1+ pos !
      repeat
      inbuf wstart @ + pos @ wstart @ - process-word
    else
      pos @ 1+ pos !
    then
  repeat
;

: swap-entries { a b }
  a w-addr@ b w-addr@ a w-addr! b w-addr!
  a w-len@  b w-len@  a w-len!  b w-len!
  a w-cnt@  b w-cnt@  a w-cnt!  b w-cnt!
;

: before? { a b -- flag }
  a w-cnt@ b w-cnt@ > if true exit then
  a w-cnt@ b w-cnt@ < if false exit then
  a w-addr@ a w-len@ b w-addr@ b w-len@ compare 0<
;

variable ins-pos

: need-swap? ( -- flag )
  ins-pos @ 0 > if
    ins-pos @ 1- ins-pos @ before? 0=
  else
    false
  then
;

: sort-words ( -- )
  n-words @ 2 < if exit then
  n-words @ 1 ?do
    i ins-pos !
    begin need-swap? while
      ins-pos @ 1- ins-pos @ swap-entries
      ins-pos @ 1- ins-pos !
    repeat
  loop
;

: print-num ( n -- )
  0 <# #s #> type
;

: print-words ( -- )
  n-words @ 0 ?do
    i w-addr@ i w-len@ type
    bl emit
    i w-cnt@ print-num
    cr
  loop
;

: main ( -- )
  read-all-input
  scan-all-words
  sort-words
  print-words
;

main
