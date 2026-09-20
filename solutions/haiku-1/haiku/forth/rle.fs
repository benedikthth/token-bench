VARIABLE rle-char
VARIABLE rle-count
VARIABLE rle-index
VARIABLE input-len

: emit-num ( n -- )
  0 <# #S #> TYPE ;

: process-run
  rle-char @ EMIT
  rle-count @ emit-num ;

: rle-read-line ( addr -- len )
  >R 0
  BEGIN
    KEY DUP 10 = 0= WHILE
    OVER R@ + C!
    1+
  REPEAT
  DROP R> ;

: process-input ( addr len -- )
  DUP 0= IF
    2DROP EXIT
  THEN

  input-len !

  DUP 0= IF
    DROP EXIT
  THEN

  C@ rle-char !
  1 rle-count !
  1 rle-index !

  BEGIN
    rle-index @ input-len @ <
  WHILE
    SWAP DUP rle-index @ + C@ DUP rle-char @ = IF
      DROP rle-count @ 1+ rle-count !
    ELSE
      process-run
      rle-char !
      1 rle-count !
    THEN
    SWAP
    rle-index @ 1+ rle-index !
  REPEAT

  DROP
  process-run
;

PAD rle-read-line process-input
