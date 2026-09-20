# Read all lines from stdin
ReadLines ← {
  line ← •GetLine ""
  (≠ line) = 0 ? ⟨⟩ ; ⟨line⟩ ∾ ReadLines ""
}
words ← ReadLines ""

# Function to create canonical form (sort characters)
Canon ← {⊏˜⍋⊢}

# Get canonical form for each word
canons ← Canon¨ words

# Group words by canonical form
groups ← canons ⊔ words

# Sort within each group
sortedGroups ← {⊏˜⍋⊢}¨ groups

# Get first word of each group (for sorting groups)
firstWords ← {⊑⊢}¨ sortedGroups

# Get indices that would sort groups by first word
indices ← ⍋ firstWords

# Reorder groups
finalGroups ← indices ⊏ sortedGroups

# Convert each group to space-separated string
{ {⊢ ∾ " " ∾ ⊣} / ⊢ }¨ finalGroups
