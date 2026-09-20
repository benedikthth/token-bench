\ Primes up to N via sieve of Eratosthenes

100001 constant maxn
create sieve maxn allot

: read-n ( -- n )
  pad 64 stdin read-line throw drop
  >r 0 0 pad r> bl skip >number 2drop drop ;

: mark-composites ( n -- )
  dup 2 ?do
    i sieve + c@ 0= if
      dup i i * > if
        dup i i * do
          1 i sieve + c!
        j +loop
      then
    then
  loop drop ;

: print-primes ( n -- )
  0 swap  ( flag n )
  1+ 2 ?do
    i sieve + c@ 0= if
      dup if space then
      i 0 .r
      drop -1
    then
  loop drop cr ;

: main
  read-n
  sieve maxn erase
  dup 2 < if drop cr exit then
  dup 1+ mark-composites
  print-primes ;

main
