# Expression calculator: recursive descent over a string with a trailing sentinel.
Ops ← "+-*/"
Div ← +0 ⍜⌵⌊ ÷    # integer division truncating toward zero
Dig ← ↧⊃(≥@0|≤@9) # digit mask
# Number: s -> s' v
Number ← ⊃(↘|⋕↙) ˜⊗0 ⊸Dig
# Apply a binary op by index: idx w v -> op(v, w)
Op ← ⨬(+|-|×|Div)
# P: lvl s -> s' v   (lvl 0 = expr, 1 = term, 2 = factor)
P ← |2.2 ⨬(
  ⍢(⊙(Op :) P ⊙⊃(↘1|⊗Ops⊢) 1|=0 ⌊÷2 ⊗Ops⊢) P 1
| ⍢(⊙(Op :) P ⊙⊃(↘1|⊗Ops⊢) 2|=1 ⌊÷2 ⊗Ops⊢) P 2
| ⨬(Number|↘1 P 0 ↘1) =@( ⊸⊢
)
Fmt   ← ⨬(°⋕|⊂@-°⋕⌵) ⊸<0
Solve ← &p Fmt ◌ P 0 ˜⊂@\0
Clean ← ▽⊸(↧⊃(≥@(|≤@9))
Line  ← ⨬(◌|Solve) ⊸(>0⧻) Clean
◌ ⍢(&sc Line|=1 type) &sc
