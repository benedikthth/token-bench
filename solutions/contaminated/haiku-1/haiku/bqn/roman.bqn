# Convert number to Roman numeral
ToRoman ← {
  vals ← ⟨1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1⟩
  syms ← ⟨"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"⟩

  Loop ← {i ← 𝕩[0]; n ← 𝕩[1]; r ← 𝕩[2]; (i ≥ ≠vals) ? r : ((n ≥ vals[i]) ? (Loop ⟨i, n - vals[i], r ∾ syms[i]⟩) : (Loop ⟨i + 1, n, r⟩))}

  Loop ⟨0, 𝕩, ""⟩
}

# Parse integer from string
ParseInt ← {
  digits ← "0123456789"
  result ← 0
  {result ← result × 10 + (digits ⊐ 𝕩)}¨ 𝕩
  result
}

# Read lines from stdin
ReadLines ← {line ← •GetLine ""; (≠ line) = 0 ? ⟨⟩ : (⟨line⟩ ∾ (ReadLines ""))}

# Main
lines ← ReadLines ""
{•Out ToRoman ParseInt 𝕩}¨ lines
