100001 constant maxn
create sieve maxn allot
variable n
variable first

: read-n ( -- n )
  0 stdin slurp-fid bounds ?do
    i c@ dup [char] 0 [char] 9 1+ within if
      [char] 0 - swap 10 * +
    else drop then
  loop ;

: emit-prime ( p -- )
  first @ if false first ! else space then
  0 .r ;

: main
  read-n n !
  sieve maxn erase
  true first !
  n @ 1+ 2 ?do
    sieve i + c@ 0= if
      i emit-prime
      i i * n @ <= if
        n @ 1+ i i * ?do 1 sieve i + c! j +loop
      then
    then
  loop
  cr ;

main
