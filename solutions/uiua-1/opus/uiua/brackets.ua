Raw  ← ▽≠@\r⟜∘ &fras "/dev/stdin"
S    ← ⍥(↘¯1)×>0⧻Raw=@\n⊣⊂@\nRaw Raw
A    ← ˜⊏[1 2 3 ¯1 ¯2 ¯3 0]⊗"([{)]}\n" S
Mask ← ×⊃(>0↘¯1|=0+⊃(↘¯1|↘1))
Step ← ▽¬↥⊃(⊂0|˜⊂0)⊸Mask
R    ← ⊂0⍥Step ⌈÷2⧻A A
Ok   ← ⊕(=1⧻) -1\+=0R R
≡(&p°□)˜⊏{"no" "yes"} Ok
