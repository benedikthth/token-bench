n ← •ParseFloat ⊑ (' '⊸≠)⊸/¨ •FLines "/dev/stdin"
s ← (↕n+1)≥2
i ← 2
{𝕤
  {𝕤 ⋄ idx ← (i×i)+i×↕1+⌊(n-i×i)÷i ⋄ s ↩ (0¨)⌾(idx⊸⊏) s}⍟(i⊑s) @
  i +↩ 1
} •_while_ {𝕤 ⋄ (i×i)≤n} @
•Out 1↓∾(' '⊸∾•Repr)¨ /s
