\ Dijkstra's algorithm in Forth

1000 CONSTANT MAX-N
1000000 CONSTANT INF
10000 CONSTANT MAX-EDGES

VARIABLE n VARIABLE m VARIABLE s VARIABLE t
VARIABLE edge-count 0 edge-count !

CREATE dist MAX-N CELLS ALLOT
CREATE visited MAX-N CELLS ALLOT
CREATE edges MAX-EDGES 3 * CELLS ALLOT

: edge-u ( i -- u ) 3 * CELLS edges + @ ;
: edge-v ( i -- v ) 3 * CELLS edges + CELL + @ ;
: edge-w ( i -- w ) 3 * CELLS edges + 2 CELLS + @ ;

: add-edge ( u v w -- )
  edge-count @ 3 * CELLS edges + >R
  SWAP R@ 2 CELLS + !
  SWAP R@ CELL + !
  SWAP R@ !
  R> DROP
  edge-count @ 1 + edge-count !
;

: parse-line PAD 256 STDIN READ-LINE DROP NIP EVALUATE ;

: init-dist n @ 0 DO INF dist I CELLS + ! LOOP ;
: init-visited n @ 0 DO 0 visited I CELLS + ! LOOP ;
: @dist CELLS dist + @ ;
: !dist CELLS dist + ! ;
: @visited CELLS visited + @ ;
: !visited CELLS visited + 1 SWAP ! ;

: dijkstra
  s @ t @ = IF 0 EXIT THEN
  init-dist
  init-visited
  0 s @ !dist
  n @ 0 DO
    -1 INF
    n @ 0 DO
      DUP I @visited 0= IF
        I @dist ROT < IF SWAP DROP I SWAP THEN
      THEN
    LOOP
    SWAP DROP
    DUP -1 = IF DROP LEAVE THEN
    DUP !visited
    edge-count @ 0 DO
      I edge-u OVER = IF
        I edge-v >R
        I edge-w DUP @dist +
        R@ @dist OVER < IF R@ !dist THEN
        DROP R> DROP
      THEN
    LOOP
    DROP
  LOOP
  t @ @dist DUP INF = IF DROP -1 THEN
;

parse-line m ! n !
m @ 0 DO parse-line add-edge LOOP
parse-line t ! s !
dijkstra . CR
BYE
