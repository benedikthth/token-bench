create buf1 2100 allot
create buf2 2100 allot
variable len1  variable len2
create row-a 2100 cells allot
create row-b 2100 cells allot
variable pp  variable cp

: strip ( addr u -- u' )
  begin dup while
    2dup + 1- c@ 32 <= while 1-
  repeat then nip ;

: rd ( addr -- u )
  dup 2090 stdin read-line throw drop strip ;

: lcs ( -- n )
  row-a 2100 cells erase  row-b 2100 cells erase
  row-a pp !  row-b cp !
  len1 @ 0 ?do
    0 cp @ !
    buf1 i + c@
    len2 @ 0 ?do
      dup buf2 i + c@ = if
        pp @ i cells + @ 1+
      else
        pp @ i 1+ cells + @  cp @ i cells + @  max
      then
      cp @ i 1+ cells + !
    loop drop
    pp @ cp @ pp ! cp !
  loop
  pp @ len2 @ cells + @ ;

buf1 rd len1 !
buf2 rd len2 !
lcs 0 .r cr
