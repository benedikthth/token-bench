# Check if character is ASCII letter
IsLetter ← {(65≤𝕩)∧(𝕩≤90)∨(97≤𝕩)∧(𝕩≤122)}

# Convert to lowercase
ToLower ← {(65≤𝕩)∧(𝕩≤90) ? 𝕩+32 ; 𝕩}

# Extract words from text
ExtractWords ← {
  text ← 𝕩
  mask ← IsLetter¨ text
  groups ← +` ¬mask
  wordGroups ← ∧ groups ⇐ mask

  GetWord ← {
    groupNum ← 𝕩
    indices ← (groups = groupNum) / ↕≠text
    text ⊏ indices
  }

  GetWord¨ wordGroups
}

# Read all lines
ReadAllLines ← {line ← •GetLine "" ⋄ (≠line)=0 ? ⟨⟩ ; ⟨line⟩∾ReadAllLines ""}

lines ← ReadAllLines ""

# Extract words from all lines
allRawWords ← ∾ (ExtractWords¨ lines)

# Convert to lowercase
allWords ← (ToLower¨)¨ allRawWords

# Get unique and count
unique ← ∧ allWords
counts ← +´ allWords =⌜ unique

# Sort
sortIdx ← ⍋ (-counts) ⋈ unique
sorted ← sortIdx ⊏ unique
sortedCounts ← sortIdx ⊏ counts

# Output: for each index, output word and count
{
  word ← 𝕩 ⊏ sorted
  count ← 𝕩 ⊏ sortedCounts
  •Out (∾ word) ∾ " " ∾ •Fmt count
}¨ ↕≢sorted
