⎕IO←1
lines←⊃⎕NGET'/dev/stdin' 1
parse←{⍎'¯'@(⍸'-'=⍵)⊢⍵}
r c←parse⊃lines
nums←parse¨r↑1↓lines
m←r c⍴⊃,/,¨nums
t←⍉m
fmt←{s←¯1↓⊃,/(⍕¨⍵),¨' ' ⋄ '-'@(⍸'¯'=s)⊢s}
out←⊃,/(fmt¨↓t),¨⎕UCS 10
(⊂out)⎕NPUT'/dev/stdout' 2
