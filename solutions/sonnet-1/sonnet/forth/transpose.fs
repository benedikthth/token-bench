\ Transpose an R x C matrix read from stdin.

DECIMAL

4096 CONSTANT LINE-MAX
CREATE LBUF LINE-MAX CHARS ALLOT

: get-line ( -- addr len )
  LBUF LINE-MAX stdin read-line throw DROP
  LBUF SWAP ;

VARIABLE R
VARIABLE C
VARIABLE MAT-ADDR

: idx ( r c -- offset ) SWAP C @ * + ;
: mat! ( n r c -- ) idx CELLS MAT-ADDR @ + ! ;
: mat@ ( r c -- n ) idx CELLS MAT-ADDR @ + @ ;

VARIABLE CUR-ROW

: store-row ( r -- )
  CUR-ROW !
  0 C @ 1- DO
    CUR-ROW @ I mat!
  -1 +LOOP ;

: read-rows
  R @ 0 DO
    get-line EVALUATE
    I store-row
  LOOP ;

: print-matrix
  C @ 0 DO
    R @ 0 DO
      I J mat@ .
    LOOP
    CR
  LOOP ;

: main
  get-line EVALUATE
  C ! R !
  R @ C @ * CELLS ALLOCATE THROW MAT-ADDR !
  read-rows
  print-matrix ;

main
