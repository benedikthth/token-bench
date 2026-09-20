0 value buf  0 value blen  0 value cap  0 value tsize  0 value table
0 value waddr  0 value wlen  0 value wcnt  0 value nwords
0 value idx  0 value tmp  0 value step  0 value start

: cells-alloc ( n -- addr ) 1+ cells allocate throw ;

: lower ( -- )
  blen 0 ?do
    buf i + c@ dup [char] A >= over [char] Z <= and
    if 32 + buf i + c! else drop then
  loop ;

: letter? ( c -- f ) dup [char] a >= swap [char] z <= and ;

: hash { a u -- h }
  0 u 0 ?do 31 * a i + c@ + loop tsize 1- and ;

: add-word { a u -- }
  a u hash begin
    table over cells + @ ?dup 0= if
      nwords 1+ table rot cells + !
      a waddr nwords cells + !
      u wlen nwords cells + !
      1 wcnt nwords cells + !
      nwords 1+ to nwords exit
    then
    1- >r
    waddr r@ cells + @ wlen r@ cells + @ a u compare 0= if
      1 wcnt r> cells + +! drop exit
    then
    r> drop 1+ tsize 1- and
  again ;

: scan-words ( -- )
  0 begin dup blen < while
    buf over + c@ letter? if
      dup begin 1+ dup blen < if buf over + c@ letter? else false then while repeat
      ( start end ) tuck over - swap buf + swap add-word
    else 1+ then
  repeat drop ;

: before? { e1 e2 -- f }
  wcnt e1 cells + @ wcnt e2 cells + @ 2dup <> if > exit then 2drop
  waddr e1 cells + @ wlen e1 cells + @
  waddr e2 cells + @ wlen e2 cells + @ compare 0< ;

: merge { lo mid hi -- }
  lo mid lo { p q k }
  begin k hi < while
    p mid < if
      q hi < if idx p cells + @ idx q cells + @ before? else true then
    else false then
    if idx p cells + @ tmp k cells + ! p 1+ to p
    else idx q cells + @ tmp k cells + ! q 1+ to q then
    k 1+ to k
  repeat
  tmp lo cells + idx lo cells + hi lo - cells move ;

: msort ( -- )
  1 to step begin step nwords < while
    0 to start begin start nwords < while
      start  start step + nwords min  start step 2* + nwords min  merge
      start step 2* + to start
    repeat
    step 2* to step
  repeat ;

: output ( -- )
  nwords 0 ?do
    idx i cells + @
    dup waddr swap cells + @ over wlen swap cells + @ type space
    wcnt swap cells + @ 0 .r cr
  loop ;

: main ( -- )
  stdin slurp-fid to blen to buf
  lower
  blen 2/ 2 + to cap
  16 begin dup cap 2* < while 2* repeat to tsize
  tsize cells-alloc to table  table tsize cells erase
  cap cells-alloc to waddr  cap cells-alloc to wlen  cap cells-alloc to wcnt
  scan-words
  nwords cells-alloc to idx  nwords 0 ?do i idx i cells + ! loop
  nwords cells-alloc to tmp
  msort output ;

main
