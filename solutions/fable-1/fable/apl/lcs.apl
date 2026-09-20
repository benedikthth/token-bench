⍝ Longest common subsequence length, row-by-row DP with vectorised row update.
lines←''
:Trap 0 1000
    lines←⊃⎕NGET '/dev/stdin' 1
:EndTrap
lines←2↑lines,⊂''
(a b)←(~∘(⎕UCS 13 10))¨lines
p←(1+≢b)⍴0
:For c :In a
    p←⌈\p⌈0,(¯1↓p)+c=b
:EndFor
⎕←⊃⌽p
