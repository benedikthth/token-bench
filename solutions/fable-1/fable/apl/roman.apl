⎕IO←1
vals←1000 900 500 400 100 90 50 40 10 9 5 4 1
syms←'M' 'CM' 'D' 'CD' 'C' 'XC' 'L' 'XL' 'X' 'IX' 'V' 'IV' 'I'

∇ r←Roman n;i
  r←''
  :For i :In ⍳≢vals
      :While n≥i⊃vals
          r,←i⊃syms
          n-←i⊃vals
      :EndWhile
  :EndFor
∇

∇ Main;lines;line;out
  lines←⊃⎕NGET'/dev/stdin' 1
  out←''
  :For line :In lines
      line←(line≠⎕UCS 13)/line
      :If 0<≢line~' '
          out,←(Roman⍎line),⎕UCS 10
      :EndIf
  :EndFor
  (⊂out)⎕NPUT'/dev/stdout' 1
∇

Main
