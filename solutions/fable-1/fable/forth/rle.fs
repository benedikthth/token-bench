\ Run-length encoding
create buf 1000000 allot

variable len
variable cur
variable cnt

: emit-run ( -- )
  cur @ emit
  cnt @ 0 .r ;

: main ( -- )
  buf 1000000 stdin read-line throw drop len !
  \ strip trailing CR if present
  len @ 0> if
    buf len @ 1- + c@ 13 = if len @ 1- len ! then
  then
  len @ 0= if cr exit then
  buf c@ cur !  1 cnt !
  len @ 1 ?do
    buf i + c@ dup cur @ = if
      drop cnt @ 1+ cnt !
    else
      emit-run cur ! 1 cnt !
    then
  loop
  emit-run cr ;

main
