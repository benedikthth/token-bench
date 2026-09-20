lines ← •FLines "/dev/stdin"

# Split by finding indices and slicing
Split ← {str:
  # Get positions where space occurs
  spaces ← ' ' = str
  # Positions of spaces
  sp_pos ← ⊐ spaces /˜ ↕≠str
  # Need to add boundaries
  boundaries ← ⟨0⟩ ∾ (sp_pos + 1) ∾ ⟨≠str⟩
  # Extract substrings between boundaries
  parts ← ⟨⟩
  {
    start ← boundaries.𝕩
    end ← boundaries.(𝕩+1)
    part ← start ↑ end ↓ str
    part ≠ "" ⊣ parts ∾↩ ⟨part⟩
  } ¨ ↕ (≠boundaries) - 1
  parts
}

# Test split
first_line ← ⊑ lines
parts ← Split first_line
•Out "Parts:"
•Out ¨ parts
•Out "Number of parts:"
•Out •Fmt ≠ parts
