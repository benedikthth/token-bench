\ Longest common subsequence of two lines read from stdin.

4096 constant maxlen

create bufa maxlen allot
create bufb maxlen allot
variable lena
variable lenb

create prev maxlen 1+ cells allot
create cur  maxlen 1+ cells allot

\ Remove a trailing carriage return, if any.
: strip-cr ( addr len -- len' )
  dup 0> if
    2dup + 1- c@ 13 = if 1- then
  then nip ;

\ Read one line into addr; missing line (EOF) counts as empty.
: read-str ( addr -- len )
  dup maxlen stdin read-line throw drop
  strip-cr ;

: lcs ( -- n )
  prev maxlen 1+ cells erase
  cur  maxlen 1+ cells erase
  lena @ 0 ?do
    bufa i + c@                     ( ca )
    0 cur !
    lenb @ 0 ?do
      dup bufb i + c@ = if
        prev i cells + @ 1+
      else
        prev i 1+ cells + @  cur i cells + @  max
      then
      cur i 1+ cells + !
    loop
    drop
    cur prev maxlen 1+ cells move
  loop
  prev lenb @ cells + @ ;

: main
  bufa read-str lena !
  bufb read-str lenb !
  lcs 0 .r cr ;

main
