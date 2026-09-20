text ← •file.Chars "/dev/stdin"
lower ← text + 32×(text≥'A')∧(text≤'Z')
b ← (lower≥'a')∧(lower≤'z')
pb ← »b
s ← b∧¬pb
g ← ¯1 + b×(+`s)
words ← g⊔lower
uniqueWords ← ⍷words
ids ← uniqueWords⊐words
counts ← ≠¨ids⊔words
o1 ← ⍋uniqueWords
w1 ← o1⊏uniqueWords
c1 ← o1⊏counts
o2 ← ⍒c1
wFinal ← o2⊏w1
cFinal ← o2⊏c1
lines ← wFinal {𝕨∾' '∾•Fmt 𝕩}¨ cFinal
•Out¨ lines
