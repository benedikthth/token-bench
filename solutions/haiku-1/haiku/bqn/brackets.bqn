CheckBalanced ← {
  opens ← "([{"
  closes ← ")]}"

  Process ← {(𝕩 ∊ opens) ? (𝕨 ∾ ⟨𝕩⟩) : (𝕩 ∊ closes) ? {(((≠𝕨) > 0) ∧ ((opens ⊑ closes ⊐ 𝕩) = ⊑⌽𝕨)) ? (¯1 ↓ 𝕨) : (𝕨 ∾ ⟨'E'⟩)} : 𝕨}

  final ← Process / ⟨⟩ , 𝕩
  (≠final = 0) ∧ (final ≠ ⟨'E'⟩)
}

input ← •GetLine ""
nl ← @10
lines ← (input ≠ nl) ⊸ ⊔ input

{CheckBalanced 𝕩 ? •Out "yes" : •Out "no"} ¨ lines
