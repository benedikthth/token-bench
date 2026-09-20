StripCr ← {(𝕩≠@+13)/𝕩}

raw ← •FLines "/dev/stdin"
stripped ← StripCr¨ raw
pad ← (0⌈2-≠stripped) ⥊ <""
lines ← stripped ∾ pad
a ← 0⊑lines
b ← 1⊑lines

# One DP row update, vectorised via a running max.
# Property used: cur[j] = max(cur[j-1], val[j]) where
#   val[j] = prev[j-1]+1 if the characters match, else prev[j]
# (this holds because cur[j-1] <= prev[j-1]+1 always).
# 𝕨: current character of a, 𝕩: previous row (length ≠b + 1)
Row ← {
  prev ← 𝕩
  eq ← 𝕨 = b
  same ← 1↓prev
  plus ← 1 + ¯1↓prev
  val ← same + eq × (plus - same)
  0 ∾ ⌈` val
}

m ← ≠b
row0 ← (m+1) ⥊ 0
final ← row0 Row´ ⌽a

•Out •Fmt ¯1⊑final
