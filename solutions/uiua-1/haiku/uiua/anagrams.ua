# Read and clean input
Words ← □ ↯ (≠ "") (÷ "\n" ⇌;$"")

# For each word, get its sorted form
Sorted_Words ← ↯ ◡ Words

# Find how to rearrange to group by sorted form
# First pair up: (sorted_index, word_index) and sort
Indices ← ⇡ ⧻ Words
Pairs_Idx ← □ (⊂ Sorted_Words Indices)
Sorted_Pairs_Idx ← ↥ Pairs_Idx

# Extract the word indices in sorted order
Word_Indices ← ↯ ⊡1 Sorted_Pairs_Idx
Reordered ← ↯ ⊡ . Word_Indices Words

# Extract sorted keys again for comparison
Sort_Keys ← ↯ ⊡0 Sorted_Pairs_Idx

# Find where sorted key changes to create groups
Key_Changes ← ⊕ (≠ .) (▭ [0 | .] Sort_Keys) Sort_Keys
Group_IDs ← +` Key_Changes

# Get unique keys
Unique_Keys ← ⊚ Sort_Keys

# For each group, collect words
Groups ← ↯ (: " ") (↯ (□ ↯ ⊡ . (□ ↯ (= .) Group_IDs) Reordered) Unique_Keys)

: "\n" Groups
