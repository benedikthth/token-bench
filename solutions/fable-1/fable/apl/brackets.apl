∇ r←Bal s;st;c;i
  st←⍬ ⋄ r←0
  :For c :In s
      :If c∊'([{'
          st,←c
      :ElseIf c∊')]}'
          :If 0=≢st ⋄ :Return ⋄ :EndIf
          :If (⊃⌽st)≠'([{'[')]}'⍳c] ⋄ :Return ⋄ :EndIf
          st←¯1↓st
      :EndIf
  :EndFor
  r←0=≢st
∇

lines←⊃⎕NGET'/dev/stdin' 1
out←⍬
:For l :In lines
    out,←⊂(1+Bal l~⎕UCS 13 10)⊃'no' 'yes'
:EndFor
:If 0<≢out
    (⊂out)⎕NPUT'/dev/stdout' 1
:EndIf
