# Longest Common Subsequence

# Read two lines
s1 ← •GetLine ""
s2 ← •GetLine ""

# Get lengths
m ← ≠ s1
n ← ≠ s2

# Initialize DP table as flat array
dp ← ((m+1) × (n+1)) ⥊ 0

# For each row i from 1 to m
{
  i ← 1 + 𝕩
  # For each column j from 1 to n
  {
    j ← 1 + 𝕩
    # Calculate indices in flat array
    idx ← i × (n+1) + j
    idx_diag ← (i-1) × (n+1) + (j-1)
    idx_up ← (i-1) × (n+1) + j
    idx_left ← i × (n+1) + (j-1)

    # Get characters
    c1 ← s1 ⊑ (i-1)
    c2 ← s2 ⊑ (j-1)

    # Update value based on character match
    dp ⊑ idx ↩ (c1 = c2) × (1 + dp ⊑ idx_diag) + (c1 ≠ c2) × ((dp ⊑ idx_up) ∨ (dp ⊑ idx_left))
  } ¨ ↕ n
} ¨ ↕ m

# Output the result at position [m,n]
ans ← dp ⊑ (m × (n+1) + n)
•Out (•Fmt ans)
