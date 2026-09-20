lines ← •FLines "/dev/stdin"
t ← ∾ lines ∾¨ <@+10
lo ← t + 32×(t≥'A')∧t≤'Z'
isl ← (lo≥'a')∧lo≤'z'
starts ← isl∧¬»isl
words ← ((isl/+`starts)-1) ⊔ isl/lo
u ← ⍷ words
c ← ≠¨ ⊔ u⊐words
o ← ⍋ u
o ↩ (⍒ o⊏c) ⊏ o
•Out¨ (o⊏u) ∾¨ (<" ")∾¨ •Repr¨ o⊏c
