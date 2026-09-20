StripCr ← {(𝕩≠@+13)/𝕩}

# Split a string on single spaces into a list of substrings.
Split ← {
  t ← 𝕩
  m ← t≠' '
  k ← +`t=' '
  (m/k)⊔(m/t)
}

lines ← StripCr¨ •FLines "/dev/stdin"

header ← •ParseFloat¨ Split 0⊑lines
rows ← 0⊑header
cols ← 1⊑header

matRows ← rows↑1↓lines
mat ← {•ParseFloat¨ Split 𝕩}¨ matRows

arr ← >mat
trans ← ⍉arr

{•Out 1↓∾' '∾¨•Fmt¨𝕩}¨ <˘trans
