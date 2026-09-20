IsUpper  ← ×⊃(≥@A)(≤@Z)
Lower    ← +(×32⊸IsUpper)
IsLetter ← ×⊃(≥@a)(≤@z)

Input  ← &rs ∞ 0
Words  ← ⊜□⊸IsLetter Lower Input
Sorted ← ⍆ Words
Ids    ← ⊛ Sorted
Counts ← ⊕⧻ Ids Sorted
Uniq   ← ◴ Sorted
Order  ← ⍏ ¯Counts
FW     ← ⊏ Order Uniq
FC     ← ⊏ Order Counts
Lines  ← ⍚($"_ _"°□) FW FC
⍚&p Lines
