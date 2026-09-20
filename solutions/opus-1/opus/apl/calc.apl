⎕IO←0 ⋄ ⎕PP←34 ⋄ ⎕FR←1287

∇ v←Expr;o;w
  v←Term
  :While P<≢T
      o←⊃P⊃T
      :If ~o∊'+-'
          :Leave
      :EndIf
      P+←1
      w←Term
      :If o='+'
          v←v+w
      :Else
          v←v-w
      :EndIf
  :EndWhile
∇

∇ v←Term;o;w
  v←Factor
  :While P<≢T
      o←⊃P⊃T
      :If ~o∊'*/'
          :Leave
      :EndIf
      P+←1
      w←Factor
      :If o='*'
          v←v×w
      :Else
          v←(×v×w)×⌊(|v)÷|w
      :EndIf
  :EndWhile
∇

∇ v←Factor;t
  t←P⊃T
  P+←1
  :If '('=⊃t
      v←Expr
      P+←1
  :Else
      v←⍎t
  :EndIf
∇

∇ Main;lines;line;out
  lines←⊃⎕NGET'/dev/stdin' 1
  out←⍬
  :For line :In lines
      T←'\d+|[-+*/()]'⎕S'&'⊢line
      :If 0<≢T
          P←0
          out,←⊂,('¯'⎕R'-')⍕Expr
      :EndIf
  :EndFor
  :If 0<≢out
      (⊂out)⎕NPUT'/dev/stdout' 2
  :EndIf
∇

Main
