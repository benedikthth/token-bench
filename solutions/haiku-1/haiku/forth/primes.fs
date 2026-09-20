variable n
variable sieve-i
variable sieve-j
variable sieve-k
variable first

create prime-array 100001 allot

: accumulate-digit ( accum char -- accum' )
  48 - >r 10 * r> + ;

: read-int
  0
  begin
    key dup 10 <> over 13 <> and
  while
    accumulate-digit
  repeat
  n ! ;

: sieve
  n @ dup 2 < if drop exit then

  prime-array n @ 1 + 1 fill
  0 prime-array c!
  1 prime-array 1+ c!

  2 sieve-i !
  begin
    sieve-i @ dup * n @ <= while
    sieve-i @ prime-array + c@ if
      sieve-i @ dup + sieve-j !
      begin
        sieve-j @ n @ <= while
        0 prime-array sieve-j @ + c!
        sieve-i @ sieve-j +!
      repeat
    then
    1 sieve-i +!
  repeat

  1 first !
  2 sieve-k !
  begin
    sieve-k @ n @ <= while
    prime-array sieve-k @ + c@ if
      first @ if
        0 first !
      else
        [char] space emit
      then
      sieve-k @ .
    then
    1 sieve-k +!
  repeat ;

read-int
sieve
bye
