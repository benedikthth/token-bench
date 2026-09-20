c ← •FChars "/dev/stdin"
c +↩ 32×(c≥'A')∧c≤'Z'
l ← (c≥'a')∧c≤'z'
w ← (¯1+l×+`l>»l) ⊔ c
u ← ∧⍷w
n ← /⁼u⊐w
•Out¨ (⍒n) ⊏ u {𝕨∾" "∾•Fmt 𝕩}¨ n
