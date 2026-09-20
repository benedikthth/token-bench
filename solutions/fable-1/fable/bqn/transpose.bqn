lines ← •FLines "/dev/stdin"
Split ← {b ← ' '=𝕩 ⋄ (0<≠¨)⊸/ (((+`b)×¬b)-b)⊔𝕩}
Nums ← {𝕊 s: •ParseFloat¨ Split s}
Digits ← {𝕩=0 ? "" ; ('0'+10|𝕩) ∾ 𝕊 ⌊𝕩÷10}
Fmt ← {0=𝕩 ? "0" ; ((𝕩<0)/"-") ∾ ⌽Digits |𝕩}
hdr ← Nums ⊑lines
r ← ⊑hdr ⋄ c ← 1⊑hdr
rows ← Nums¨ r↑1↓lines
m ← r‿c⥊∾rows
{•Out 1↓∾(' '∾Fmt)¨𝕩}˘ ⍉m
