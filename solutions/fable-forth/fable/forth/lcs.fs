\ Longest common subsequence length, two-row DP.

4096 constant maxlen
create abuf maxlen allot
create bbuf maxlen allot
variable na
variable nb
create row0 maxlen cells allot
create row1 maxlen cells allot
variable prev
variable cur

: trim-tail ( addr len -- len' )
  begin
    dup 0> if
      2dup + 1- c@ dup 13 = swap dup 10 = swap 32 = or or
    else false then
  while 1- repeat
  nip ;

: read-str ( addr -- len )
  dup maxlen stdin read-line throw drop trim-tail ;

: lcs ( -- n )
  row0 prev !  row1 cur !
  nb @ 1+ 0 ?do 0 prev @ i cells + ! loop
  na @ 0 ?do
    0 cur @ !
    abuf i + c@
    nb @ 0 ?do
      dup bbuf i + c@ = if
        prev @ i cells + @ 1+
      else
        prev @ i 1+ cells + @  cur @ i cells + @ max
      then
      cur @ i 1+ cells + !
    loop
    drop
    prev @ cur @ prev ! cur !
  loop
  prev @ nb @ cells + @ ;

: main
  abuf read-str na !
  bbuf read-str nb !
  lcs 0 .r cr ;

main
