\ Run-length encoding

256 constant maxlen
create linebuf maxlen allot

variable a-addr
variable a-len
variable idx
variable cur
variable cnt

: emit-run ( -- )
  cur @ emit
  cnt @ 0 .r ;

: rle ( addr len -- )
  a-len !  a-addr !
  a-len @ 0= if exit then
  a-addr @ c@ cur !
  1 cnt !
  1 idx !
  begin idx @ a-len @ < while
    a-addr @ idx @ + c@
    dup cur @ = if
      drop cnt @ 1+ cnt !
    else
      emit-run
      cur !
      1 cnt !
    then
    idx @ 1+ idx !
  repeat
  emit-run ;

: main
  linebuf maxlen stdin read-line throw
  ( u2 flag )
  if
    linebuf swap rle
  else
    drop
  then
  cr ;

main
