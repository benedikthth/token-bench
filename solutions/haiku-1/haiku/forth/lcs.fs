: read-line { addr max -- len }
  ." read-line called" cr
  0 { len }
  begin
    key dup 10 <>
  while
    addr len + c!
    len 1+ to len
    len max >= if leave then
  repeat
  len
;

: lcs { s1 s1len s2 s2len -- n }
  ." lcs called with s1len=" s1len . ." s2len=" s2len . cr
  s1len 1+ s2len 1+ * cells allocate throw { dp }
  ." allocated!" cr
  s2len 1+ { stride }

  1 { i }
  begin i s1len 1+ <= while
    1 { j }
    begin j stride <= while
      s1 i 1- + c@ s2 j 1- + c@ = if
        dp i 1- stride * j 1- + cells + @ 1+
        dp i stride * j + cells + !
      else
        dp i 1- stride * j + cells + @
        dp i stride * j 1- + cells + @ max
        dp i stride * j + cells + !
      then
      j 1+ to j
    repeat
    i 1+ to i
  repeat

  dp s1len stride * s2len + cells + @
  dp free throw
;

: main
  ." main called" cr
  2000 allocate throw { s1 }
  ." allocated s1" cr
  2000 allocate throw { s2 }
  ." allocated s2" cr
  s1 2000 read-line { s1len }
  ." read s1, len=" s1len . cr
  s2 2000 read-line { s2len }
  ." read s2, len=" s2len . cr
  s1 s1len s2 s2len lcs . cr
  s1 free throw
  s2 free throw
;

main bye
