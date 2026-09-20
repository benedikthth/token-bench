\ Word frequency counter

: is-letter ( c -- flag )
  dup 65 90 within over 97 122 within or
;

: to-lower ( c -- c )
  dup 65 90 within if 32 + then
;

\ Word storage: just store words as we go
create words-data 100000 allot
variable words-pos
variable word-count

: init-words
  words-data words-pos !
  0 word-count !
;

\ Read a word from stdin and store into PAD
create temp-word 1000 allot
variable temp-len

: read-word ( -- len )
  0 temp-len !
  begin
    key? if
      key dup is-letter if
        to-lower temp-word temp-len @ + c!
        temp-len @ 1 + temp-len !
      else
        drop temp-len @
        dup if exit then
        0 exit
      then
    else
      temp-len @
      dup if exit then
      0 exit
    then
  until
;

\ Search for a word and return count address or -1
: find-word ( addr len -- count-addr | -1 )
  >r >r
  words-data
  begin
    dup words-pos @ <
  while
    dup c@ >r ( length of this entry )
    dup 1 + ( data start )
    2over r@ swap compare 0= if
      ( found! r@ = length, dup+1 = data, need to find count )
      r> + 1 + ( skip past data to count byte )
      r> drop r> drop
      exit
    then
    r> +  \ skip length + data + 1 for count byte
    1 +
  repeat
  drop 2drop -1
;

\ Add word or increment count
: add-word ( addr len -- )
  2dup find-word ?dup if
    nip nip c@ 1 + swap c!
  else
    \ Add new: [len][word][count]
    words-pos @ c!
    1 words-pos +!
    dup words-pos @ swap move
    words-pos +!
    1 words-pos @ c!
    1 words-pos +!
    1 word-count +!
  then
;

: main
  init-words
  begin
    read-word dup
  while
    temp-word swap add-word
  repeat
  drop

  \ Output results
  words-data
  begin
    dup words-pos @ <
  while
    dup c@ >r ( length )
    dup 1 +
    dup r@ type
    [char] space emit
    r> + c@ . cr
    1 +
  repeat
  drop
;

main bye
