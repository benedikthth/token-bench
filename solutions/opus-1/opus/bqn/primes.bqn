n ← •ParseFloat •GetLine @
s ← 2≤↕n+1
i ← 2
{𝕤 ⋄ {s ↩ 0¨⌾(((i×i)+i×↕⌈((n+1)-i×i)÷i)⊸⊏) s}⍟(i⊑s) @ ⋄ i +↩ 1} •_while_ {𝕤 ⋄ n≥i×i} @
•Out 1↓∾{' '∾•Repr 𝕩}¨/s
