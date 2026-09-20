thousands ← ⟨"", "M", "MM", "MMM"⟩
hundreds ← ⟨"", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"⟩
tens ← ⟨"", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"⟩
units ← ⟨"", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"⟩

Roman ← {
  n ← 𝕩
  th ← ⌊n÷1000
  n ↩ n - th×1000
  h ← ⌊n÷100
  n ↩ n - h×100
  t ← ⌊n÷10
  u ← n - t×10
  (th⊑thousands)∾(h⊑hundreds)∾(t⊑tens)∾(u⊑units)
}

RemoveCR ← {(𝕩≠@+13)/𝕩}

raw ← RemoveCR¨ •FLines "/dev/stdin"
lines ← (0<≠¨raw)/raw
nums ← •BQN¨ lines
•Out¨ Roman¨nums
