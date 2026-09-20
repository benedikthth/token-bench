\ Run-length encoding
256 constant maxlen
create buf maxlen allot
variable n
variable idx
variable cnt
variable ch

: rle-num ( u -- ) 0 <# #s #> type ;

: main
  buf maxlen stdin read-line throw drop n !
  0 idx !
  begin
    idx @ n @ <
  while
    buf idx @ + c@ ch !
    1 cnt !
    begin
      idx @ cnt @ + n @ <
      if
        buf idx @ cnt @ + + c@ ch @ =
      else
        false
      then
    while
      cnt @ 1+ cnt !
    repeat
    ch @ emit
    cnt @ rle-num
    idx @ cnt @ + idx !
  repeat
  cr
;

main
