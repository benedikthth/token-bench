# Read all of stdin, lowercase, split into maximal runs of ASCII letters
Src   ← ¯⌵&rs∞0
Words ← ⊜□⊸(×⊃(≥@a)(≤@z)) Src
# Unique words (first-occurrence order) and their counts
Uniq   ← ◴ Words
Counts ← ⊕⧻⊸⊛ Words
# Sort: word ascending first (stable), then count descending (stable)
Idx   ← ⍏ ⬚@ ≡°□ Uniq
Order ← ⊏⊸(⍖⊏⊙Counts) Idx
≡(&p $"_ _" °□) ⊏Order Uniq ⊏Order Counts
