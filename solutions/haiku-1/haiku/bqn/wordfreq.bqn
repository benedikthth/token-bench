# Read all input
content ← •File ""

# Character helper functions
IsLetter ← {c ← 𝕩 ⋄ (c≥65 ∧ c≤90) ∨ (c≥97 ∧ c≤122)}
ToLower ← {c ← 𝕩 ⋄ c≥65 ∧ c≤90 ? c+32 ; c}

# Split content by word boundaries
# Group consecutive letters together
PrepareChars ← {
  text ← 𝕩
  # Create array of (isLetter, char) pairs, with lowercase conversion
  {c ← 𝕩 ⋄ IsLetter c ? ⟨1, ToLower c⟩ ; ⟨0, c⟩} ¨ text
}

pairs ← PrepareChars content

# Extract words using grouping
# Mark word group boundaries
GroupWords ← {
  pairs ← 𝕩
  # Get letter flags
  flags ← {𝕩 ⊑ 0} ¨ pairs
  # Create groups: new group when transitioning from 0 to 1
  starts ← (0 ∾ flags) < flags
  groups ← +\ starts
  # Filter to only letter groups, extract chars
  letterPairs ← (1 = flags) / pairs
  letterGroups ← (1 = flags) / groups
  # Partition by group number
  {
    groupNum ← 𝕩
    chars ← {𝕩 ⊑ 1} ¨ (letterGroups = groupNum) / letterPairs
    chars
  } ¨ ⊐ letterGroups
}

wordChars ← GroupWords pairs

# Convert character arrays to strings for comparison
CharArrayToString ← {
  chars ← 𝕩
  ⊑⟨chars⟩
}

allWords ← CharArrayToString ¨ wordChars

# Get unique words using group and count
# Use primitive operations to find unique values and count
CountWords ← {
  words ← 𝕩
  # Find unique words
  unique ← ⊐ words
  # Map each unique word to count
  counts ← {
    u ← unique ⊑ 𝕩
    +´ u ≡ words
  } ¨ ↕ ≠ unique
  ⟨unique, counts⟩
}

⟨uniqueWords, counts⟩ ← CountWords allWords

# Create results
results ← {⟨uniqueWords ⊑ 𝕩, counts ⊑ 𝕩⟩} ¨ ↕ ≠ uniqueWords

# Sort by count (desc) then word (asc)
SortKey ← {
  entry ← 𝕩
  word ← entry ⊑ 0
  count ← entry ⊑ 1
  ⟨-count, word⟩
}

sortKeys ← SortKey ¨ results
sortOrder ← ⍋ sortKeys

# Output
{
  idx ← sortOrder ⊑ 𝕩
  entry ← results ⊑ idx
  word ← entry ⊑ 0
  count ← entry ⊑ 1
  •Out word ∾ " " ∾ •Fmt count
} ¨ ↕ ≠ sortOrder
