⎕IO←0

Nums←{⍎¨(' '≠⍵)⊆⍵}

lines←⊃⎕NGET '/dev/stdin' 1
lines←{(⍵≠⎕UCS 13)/⍵}¨lines        ⍝ strip stray CR
lines←(0<≢¨lines)/lines            ⍝ drop empty lines

rc←Nums ⊃lines[0]
R←0⊃rc ⋄ C←1⊃rc

mat←↑{Nums ⊃lines[1+⍵]}¨⍳R
tmat←⍉mat

FmtRow←{
  s←1↓∊(' ',¨⍕¨tmat[⍵;])
  s[(s='¯')/⍳≢s]←'-'
  s
}
rows←FmtRow¨⍳C
⎕←∊rows[0],{(⊂⎕UCS 10),⍵}¨1↓rows

