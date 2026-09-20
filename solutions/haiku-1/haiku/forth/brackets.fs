create bracket-stack 1000 allot
create line-buffer 1000 allot
variable stack-ptr

: not ( flag -- flag )
  0=
;

: push-bracket ( c -- )
  stack-ptr @ bracket-stack + c!
  1 stack-ptr +!
;

: pop-bracket ( -- c )
  -1 stack-ptr +!
  stack-ptr @ bracket-stack + c@
;

: stack-empty? ( -- flag )
  stack-ptr @ 0=
;

: matches ( open close -- flag )
  >r over [char] ( = if r> [char] ) = exit then
  over [char] [ = if r> [char] ] = exit then
  over [char] { = if r> [char] } = exit then
  drop r> drop false
;

: is-open ( c -- flag )
  dup [char] ( = over [char] [ = over [char] { = or or nip
;

: is-close ( c -- flag )
  dup [char] ) = over [char] ] = over [char] } = or or nip
;

: check-line ( addr len -- flag )
  0 stack-ptr !

  0 do
    dup i + c@ dup is-open if
      push-bracket
    else
      dup is-close if
        stack-empty? if drop false exit then
        pop-bracket swap matches not if drop false exit then
      else
        drop
      then
    then
  loop

  drop stack-empty?
;

variable line-len

: read-line ( -- len )
  0 line-len !
  begin
    key ( c )
    dup 10 = if  \ newline
      drop line-len @ exit
    then
    dup 13 = if  \ carriage return (for Windows)
      drop
    else
      line-buffer line-len @ + c!  \ store character
      1 line-len +!  \ increment length
    then
  again
;

: main
  begin
    read-line ( len )
    dup 0= if  \ EOF (empty line at start)
      false exit
    then
    line-buffer swap check-line if
      .\" yes" cr
    else
      .\" no" cr
    then
  again
;

main
