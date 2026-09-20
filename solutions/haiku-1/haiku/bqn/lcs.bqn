a ← •GetLine @
b ← •GetLine @

m ← ≠a
n ← ≠b

# Initialize previous row with zeros
prev ← (n+1) ⥊ 0

# Process each row
{
  i ← 1+𝕩
  curr ← ⟨0⟩
  {
    j ← 1+𝕩
    idx_a ← i-1
    idx_b ← j-1
    ca ← ⟨idx_a⟩ ⊑ a
    cb ← ⟨idx_b⟩ ⊑ b
    match ← ca = cb
    prev_j ← ⟨j⟩ ⊑ prev
    prev_j_minus_1 ← ⟨idx_b⟩ ⊑ prev
    last_idx ← (≠curr) - 1
    last ← ⟨last_idx⟩ ⊑ curr
    max_val ← prev_j ⌈ last
    match_val ← 1 + prev_j_minus_1
    val ← ⟨max_val, match_val⟩ ⊐ match
    curr ∾↩ ⟨val⟩
  }¨ ↕n
  prev ↩ curr
}¨ ↕m

result ← ⟨n⟩ ⊑ prev
digits ← "0123456789"
digit_char ← ⟨result⟩ ⊐ digits
•Out digit_char
