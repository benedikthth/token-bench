cr ← @+13
Clean ← {(𝕩≠cr)/𝕩}

raw ← •FLines "/dev/stdin"
lines ← raw ∾ (0⌈2-≠raw) ⥊ ⟨""⟩
sA ← Clean ⊑lines
sB ← Clean 1⊑lines

Row ← {
  r ← 𝕨 ⋄ ch ← 𝕩
  diag ← ¯1↓r
  up ← 1↓r
  eq ← ch = sB
  m ← eq × (diag+1)
  cand ← up ⌈ m
  tail ← 0 ⌈` cand
  0∾tail
}

G ← {𝕩 Row 𝕨}
r0 ← (1+≠sB) ⥊ 0
finalRow ← r0 G´ (⌽sA)
•Show ¯1⊑finalRow
