v←1000 900 500 400 100 90 50 40 10 9 5 4 1
s←'M' 'CM' 'D' 'CD' 'C' 'XC' 'L' 'XL' 'X' 'IX' 'V' 'IV' 'I'
r←{⍵≤0:'' ⋄ i←⊃⍸v≤⍵ ⋄ (i⊃s),∇⍵-i⊃v}
l←{0::⍬ ⋄ ⊃⎕NGET'/dev/stdin' 1}0
n←∊{b x←⎕VFI ⍵ ⋄ b/x}¨l
t←'/dev/stdout'⎕NTIE 0
(∊(r¨n),¨⎕UCS 10)⎕NAPPEND t 80
⎕NUNTIE t
