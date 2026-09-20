l ← (•FLines "/dev/stdin") ∾ ⟨"", ""⟩
Strip ← {𝕩/˜𝕩≠@+13}
a ← Strip ⊑l
b ← Strip 1⊑l
Row ← {c 𝕊 p: ⌈` p ⌈ 0∾(¯1↓p)+(c=b)}
•Out •Repr ¯1⊑ Row´ (⌽a) ∾ ⟨(1+≠b)⥊0⟩
