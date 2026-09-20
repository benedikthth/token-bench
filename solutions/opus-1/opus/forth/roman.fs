create buf 256 allot

: r ( n val addr u -- n )
  2>r begin 2dup >= while tuck - swap 2r@ type repeat drop 2r> 2drop ;

: roman ( n -- )
  1000 s" M"  r  900 s" CM" r  500 s" D"  r  400 s" CD" r
  100  s" C"  r  90  s" XC" r  50  s" L"  r  40  s" XL" r
  10   s" X"  r  9   s" IX" r  5   s" V"  r  4   s" IV" r
  1    s" I"  r  drop ;

: parse-num ( addr u -- n flag )
  0 false 2swap bounds ?do
    i c@ dup [char] 0 [char] 9 1+ within if
      [char] 0 - rot 10 * + swap drop true
    else drop then
  loop ;

: main
  begin buf 256 stdin read-line throw while
    buf swap parse-num if roman cr else drop then
  repeat drop ;

main
