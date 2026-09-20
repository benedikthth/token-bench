⎕IO←1
split←{(' '≠t)⊆t←∊⍵}
lines←⊃⎕NGET '/dev/stdin' 1
hdr←⍎¨split lines[1]
R←hdr[1]
C←hdr[2]
rows←(⍎¨split)¨R↑1↓lines
mat←↑rows
t←⍉mat
fmt←{s←⍕⍵ ⋄ s[(s='¯')/⍳⍴s]←'-' ⋄ s}
outrows←{1↓∊' ',¨fmt¨⍵}¨(⊂[2]t)
nl←⎕UCS 10
⎕←⊃{⍺,nl,⍵}/outrows
