⎕IO←1
a←⍞
b←⍞
a←(a≠⎕UCS 13)/a
b←(b≠⎕UCS 13)/b
n←≢a ⋄ m←≢b
R←(m+1)⍴0
:For i :In ⍳n
  ai←a[i]
  match←b=ai
  Rshift←¯1↓R
  C←match×Rshift+1
  CM←⌈\C
  Rj←1↓R
  NR←Rj⌈CM
  R←0,NR
:EndFor
⎕←R[m+1]
