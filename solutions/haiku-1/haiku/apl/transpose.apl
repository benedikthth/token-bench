⍝ Read first line
first_line ← ⎕

⍝ Parse R and C
split_rc ← (⊂' ') ⊂ first_line
parsed ← ⍎¨ split_rc
R ← ⊃parsed
C ← ⊃1↓parsed

⍝ Read and parse matrix lines
matrix ← ⍬
:For i :In ⍳R
    line ← ⎕
    parts ← (⊂' ') ⊂ line
    matrix ← matrix, ⊂⍎¨parts
:EndFor
matrix ← ↑matrix

⍝ Transpose the matrix
transposed ← ⍉matrix

⍝ Output each row
:For row :In transposed
    ⎕← ⍕ row
:EndFor
