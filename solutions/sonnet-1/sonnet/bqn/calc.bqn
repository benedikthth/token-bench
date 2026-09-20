digits ← "0123456789"

# Truncating (toward zero) integer division
TruncDiv ← {(×𝕨×𝕩) × ⌊(|𝕨)÷|𝕩}

# Parse a run of digits starting at index 𝕩 in string 𝕨.
# Returns ⟨value, nextIndex⟩.
ParseNumber ← {
  r ← 𝕩↓𝕨
  m ← ∧` r∊digits
  n ← +´m
  ⟨•BQN n↑r, 𝕩+n⟩
}

# Parse a factor: a number or a parenthesised expression.
ParseFactor ← {
  (𝕩⊑𝕨)='(' ?
    t ← 𝕨 ParseExpr 𝕩+1
    ⟨0⊑t, (1⊑t)+1⟩
  ;
    𝕨 ParseNumber 𝕩
}

# Continue combining factors with * and / from the left.
ParseTermLoop ← {
  v ← 0⊑𝕩
  j ← 1⊑𝕩
  ((j⊑𝕨)='*') ∨ (j⊑𝕨)='/' ?
    op ← j⊑𝕨
    t ← 𝕨 ParseFactor j+1
    v2 ← 0⊑t
    j2 ← 1⊑t
    nv ← (op='*') ⊑ ⟨v TruncDiv v2, v×v2⟩
    𝕨 ParseTermLoop ⟨nv, j2⟩
  ;
    𝕩
}

ParseTerm ← {
  𝕨 ParseTermLoop (𝕨 ParseFactor 𝕩)
}

# Continue combining terms with + and - from the left.
ParseExprLoop ← {
  v ← 0⊑𝕩
  j ← 1⊑𝕩
  ((j⊑𝕨)='+') ∨ (j⊑𝕨)='-' ?
    op ← j⊑𝕨
    t ← 𝕨 ParseTerm j+1
    v2 ← 0⊑t
    j2 ← 1⊑t
    nv ← (op='+') ⊑ ⟨v-v2, v+v2⟩
    𝕨 ParseExprLoop ⟨nv, j2⟩
  ;
    𝕩
}

ParseExpr ← {
  𝕨 ParseExprLoop (𝕨 ParseTerm 𝕩)
}

FmtInt ← {
  s ← •Fmt |𝕩
  (𝕩<0) ⊑ ⟨s, '-'∾s⟩
}

rawLines ← •FLines "/dev/stdin"
lines ← (0<≠¨rawLines)/rawLines
{
  noCr ← (𝕩≠@+13)/𝕩
  line ← ((noCr≠' ')/noCr) ∾ ' '
  t ← line ParseExpr 0
  •Out FmtInt 0⊑t
}¨ lines
