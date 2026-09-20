variable R
variable C
variable result
variable neg-flag
create matrix 10000 cells allot

: get-addr ( row col -- addr )
  C @ * + cells matrix + ;

: read-int
  0 result !
  0 neg-flag !

  \ Skip leading spaces and read first non-space character
  begin key dup 32 > until

  \ Now we have the first non-space character on top of stack
  \ Check if it's a minus sign
  dup 45 = if
    drop -1 neg-flag !
    key  \ read next character
  then

  \ Parse digits starting with current character
  begin
    dup 48 57 within
  while
    48 - result @ 10 * + result !
    key
  repeat

  \ Drop the terminating character
  drop

  \ Return the result
  result @
  neg-flag @ if negate then ;

: print-number ( n -- )
  s>d <# #S #> type ;

: read-matrix
  R @ 0 do
    C @ 0 do
      read-int
      I J get-addr !
    loop
  loop
;

: print-transposed
  C @ 0 do
    R @ 0 do
      J I get-addr @
      print-number
      I R @ 1- <> if space then
    loop
    cr
  loop
;

read-int R !
read-int C !
read-matrix
print-transposed
