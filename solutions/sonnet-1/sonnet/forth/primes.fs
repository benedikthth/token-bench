\ Primes up to N

variable N
variable len
variable first?
create flags 100001 allot

: read-n ( -- n )
  pad 256 stdin read-line throw drop  ( u )
  len !
  0 0 pad len @ >number 2drop d>s ;

: .nosp ( n -- )
  s>d <# #s #> type ;

: mark-composite ( i -- )
  dup dup *  ( i i*i )
  begin
    dup N @ <=
  while
    dup flags + 1 swap c!
    over +
  repeat
  2drop ;

: sieve ( -- )
  flags 100001 0 fill
  2
  begin
    dup dup * N @ <=
  while
    dup flags + c@ 0=
    if dup mark-composite then
    1+
  repeat
  drop ;

: print-primes ( -- )
  true first? !
  2
  begin
    dup N @ <=
  while
    dup flags + c@ 0=
    if
      first? @ 0= if space then
      dup .nosp
      false first? !
    then
    1+
  repeat
  drop ;

: main
  read-n N !
  N @ 2 <
  if
    cr
  else
    sieve
    print-primes
    cr
  then ;

main
