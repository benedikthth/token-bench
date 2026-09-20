1000000 constant bufsize
create buf bufsize allot
variable len
variable cur
variable cnt

: letter? ( c -- f ) [char] a [char] z 1+ within ;
: .n ( n -- ) s>d <# #s #> type ;
: flush-run ( -- ) cnt @ if cur @ emit cnt @ .n then ;

: main
  buf bufsize stdin read-line throw drop len !
  0 cnt !
  len @ 0 ?do
    buf i + c@ dup letter? if
      dup cur @ = cnt @ 0> and if
        drop 1 cnt +!
      else
        flush-run cur ! 1 cnt !
      then
    else drop then
  loop
  flush-run cr ;

main
