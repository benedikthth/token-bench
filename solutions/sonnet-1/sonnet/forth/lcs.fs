\ Longest common subsequence

2000 constant maxlen
create buf1 maxlen allot
create buf2 maxlen allot
variable len1
variable len2

create arrA maxlen 1+ cells allot
create arrB maxlen 1+ cells allot
variable pprev
variable pcur
variable tmp

: trim-cr ( addr len -- len' )
  dup 0= if nip exit then
  2dup + 1- c@ 13 = if 1- then
  nip ;

: pget ( idx -- n ) cells pprev @ + @ ;
: cget ( idx -- n ) cells pcur @ + @ ;
: cset ( n idx -- ) cells pcur @ + ! ;

: swap-arrays
  pprev @ tmp !
  pcur @ pprev !
  tmp @ pcur !
;

: init-arrays
  arrA maxlen 1+ cells erase
  arrB maxlen 1+ cells erase
  arrA pprev !
  arrB pcur !
;

: read-input
  buf1 maxlen stdin read-line throw drop len1 !
  buf1 len1 @ trim-cr len1 !
  buf2 maxlen stdin read-line throw drop len2 !
  buf2 len2 @ trim-cr len2 !
;

: run-dp
  len1 @ 0 ?do
    0 0 cset
    len2 @ 0 ?do
      buf1 j + c@  buf2 i + c@  =
      if
        i pget 1+  i 1+ cset
      else
        i 1+ pget  i cget  max  i 1+ cset
      then
    loop
    swap-arrays
  loop
;

: print-num ( n -- )
  s>d <# #s #> type ;

: main
  init-arrays
  read-input
  run-dp
  len2 @ pget print-num cr
;

main
