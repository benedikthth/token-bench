⎕PP←34 ⋄ ⎕FR←1287
s←∊(⊃⎕NGET'/dev/stdin'1),¨' '
s←' '@(∊∘(⎕UCS 9 10 13))s
n←⍎¨(' '≠s)⊆'¯'@('-'∘=)s
r c←2↑n
m←⍉r c⍴2↓n
f←{'-'@('¯'∘=)¯1↓∊(⍕¨⍵),¨' '}
out←∊(f¨↓m),¨⎕UCS 10
t←'/dev/stdout'⎕NTIE 0
out ⎕NAPPEND t 80
⎕NUNTIE t
