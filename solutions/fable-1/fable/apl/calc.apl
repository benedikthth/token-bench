⎕IO←1 ⋄ ⎕PP←34 ⋄ ⎕FR←1287

∇ t←Tokenize s;d;i;c;n
  t←⍬ ⋄ i←1 ⋄ s←s~⎕UCS 13
  :While i≤≢s
      c←i⊃s
      :If c∊⎕D
          n←i
          :While n≤≢s
          :AndIf (n⊃s)∊⎕D
              n+←1
          :EndWhile
          t,←⊂⍎s[(i-1)+⍳n-i]
          i←n
      :ElseIf c∊'+-*/()'
          t,←c
          i+←1
      :Else
          i+←1
      :EndIf
  :EndWhile
∇

∇ r←Peek
  :If pos≤≢tok ⋄ r←pos⊃tok ⋄ :Else ⋄ r←' ' ⋄ :EndIf
∇

∇ r←Factor
  :If (Peek)≡'('
      pos+←1
      r←Expr
      pos+←1
  :Else
      r←pos⊃tok
      pos+←1
  :EndIf
∇

∇ r←Term;op;b
  r←Factor
  :While (Peek)∊'*/'
      op←Peek ⋄ pos+←1
      b←Factor
      :If op='*'
          r←r×b
      :Else
          r←(×r×b)×⌊(|r)÷|b
      :EndIf
  :EndWhile
∇

∇ r←Expr;op;b
  r←Term
  :While (Peek)∊'+-'
      op←Peek ⋄ pos+←1
      b←Term
      :If op='+' ⋄ r←r+b ⋄ :Else ⋄ r←r-b ⋄ :EndIf
  :EndWhile
∇

∇ Main;lines;l;tok;pos;out;v
  lines←⊃⎕NGET'/dev/stdin' 1
  out←''
  :For l :In lines
      tok←Tokenize l
      :If 0<≢tok
          pos←1
          v←⍕Expr
          v[(v='¯')/⍳≢v]←'-'
          out,←v,⎕UCS 10
      :EndIf
  :EndFor
  :Trap 0
      _←out ⎕NPUT'/dev/stdout' 1
  :Else
      ⎕←out
  :EndTrap
∇

Main
