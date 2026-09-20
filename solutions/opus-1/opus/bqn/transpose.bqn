lines ← ⟨⟩
line ← •GetLine@
{𝕊: lines ∾↩ <line ⋄ line ↩ •GetLine@} •_while_ {𝕊: @ ≢ line} @
txt ← ∾ (∾⟜" ")¨ lines
m ← ¬ txt ∊ " "∾(@+9)∾(@+10)∾(@+13)
toks ← ((m × +` m > »m) - 1) ⊔ txt
r‿c ← •ParseFloat¨ 2↑toks
mat ← ⍉ r‿c ⥊ 2↓toks
{•Out 1↓∾ (<" ") ∾¨ 𝕩 ⋄ 0}˘ mat
