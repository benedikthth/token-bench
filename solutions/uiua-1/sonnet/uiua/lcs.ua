# Longest common subsequence
# Reads two lines from stdin, prints the LCS length.
# 
# Standard O(n*m) DP, but computed row-by-row using array operations:
# for each character of A, the whole next DP row (length m) is derived
# from the previous row via elementwise ops plus one prefix-max scan
# (relying on the fact that each DP row is already non-decreasing, so
# max(prevRow, match*(diag+1)) followed by a running max gives the
# correct next row without an explicit per-cell branch/loop).

A ← &sc
B ← &sc

# shift a row right by one (diag values) and add 1
DiagInc ← +1⊂0↘¯1

# One DP step. Input: character c (top), previous row padded with a
# leading sentinel 0 (so it's never empty, length m+1).
# Output: next row, also padded the same way.
F ← ⊂0(\↥↥⊃(⋅∘)(×⊙DiagInc)=B)⊙(↘1)

m   ← ⧻B
Row ← ∧F A (↯(+1m)0)
&p ⊣Row
