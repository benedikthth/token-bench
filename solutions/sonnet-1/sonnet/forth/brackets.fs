\ Balanced brackets checker

256 constant max-depth
create brstack max-depth allot
variable stack-ptr
variable failed

: reset-stack ( -- ) 0 stack-ptr ! ;
: spush ( c -- ) brstack stack-ptr @ + c! 1 stack-ptr +! ;
: spop ( -- c ) -1 stack-ptr +! brstack stack-ptr @ + c@ ;
: sempty? ( -- flag ) stack-ptr @ 0= ;

: is-open? ( c -- flag )
  dup [char] ( = swap dup [char] [ = swap [char] { = or or ;

: is-close? ( c -- flag )
  dup [char] ) = swap dup [char] ] = swap [char] } = or or ;

: match-open ( c -- open )
  dup [char] ) = if drop [char] ( exit then
  dup [char] ] = if drop [char] [ exit then
  drop [char] { ;

: balanced? ( addr len -- flag )
  reset-stack
  false failed !
  bounds ?do
    i c@ >r
    r@ is-open? if
      r@ spush
    else
      r@ is-close? if
        sempty? if
          true failed !
        else
          spop r@ match-open <> if true failed ! then
        then
      then
    then
    r> drop
    failed @ if leave then
  loop
  failed @ 0= sempty? and
;

: process-line ( addr len -- )
  balanced? if ." yes" else ." no" then cr ;

256 constant line-max
create linebuf line-max allot

: main
  begin
    linebuf line-max stdin read-line throw
  while
    linebuf swap process-line
  repeat
;

main
