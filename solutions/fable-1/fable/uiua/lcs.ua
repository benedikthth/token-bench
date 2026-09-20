In    ← ⊂:"\n\n"▽≠@\r.&rs ∞ 0
Split ← ⊃(↙|↘+1)⊢⊚=@\n.
A     ← ⊙◌Split In
B     ← ⊙◌Split ◌Split In
# Row update: new[j] = max over k<=j of max(prev[k], match[k]*(prev[k-1]+1))
Step ← \↥⊂0 ↥ ⊃(↘1◌|× =B ⊙(+1↘¯1))
&p ⊢⇌ ∧Step A ↯+1⧻B 0
