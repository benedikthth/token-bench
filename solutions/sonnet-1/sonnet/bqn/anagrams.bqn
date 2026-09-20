raw ← •FLines "/dev/stdin"
words ← (0<≠¨raw) / raw

keys ← ∧¨ words
ids ← keys⊐keys
groups0 ← ids ⊔ words
groups ← (0<≠¨groups0) / groups0
sorted ← ∧¨ groups
order ← ⍋ ⊑¨sorted
final ← order⊏sorted

Join ← {1↓∾' '∾¨𝕩}
•Out¨ Join¨ final
