4000000 constant maxlen
maxlen allocate throw constant buf
maxlen allocate throw constant stk
variable depth#
variable ok

: push ( c -- ) stk depth# @ + c!  1 depth# +! ;

: pop-match ( opener -- )
  depth# @ 0= if drop false ok ! exit then
  -1 depth# +!
  stk depth# @ + c@ <> if false ok ! then ;

: check ( addr u -- flag )
  0 depth# !  true ok !
  0 ?do
    dup i + c@
    case
      [char] ( of [char] ( push endof
      [char] [ of [char] [ push endof
      [char] { of [char] { push endof
      [char] ) of [char] ( pop-match endof
      [char] ] of [char] [ pop-match endof
      [char] } of [char] { pop-match endof
    endcase
  loop drop
  ok @ depth# @ 0= and ;

: main
  begin buf maxlen stdin read-line throw while
    buf swap check if ." yes" else ." no" then cr
  repeat drop ;

main
