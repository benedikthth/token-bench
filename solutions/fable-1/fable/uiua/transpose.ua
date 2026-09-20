# Format a number, using "-" rather than "¯" for negatives
Fmt ← ⊂⊃(▽⊙"-"<0|°⋕⌵)
# Parse all integers (digits and '-' chars), reshape to R×C, transpose, print rows
≡(&p °□/$"_ _" ≡(□Fmt)) ⍉ ↯⊃(↙2|↘2) ⊜⋕⊸(↥⊃(=@-|≥@0)) &rs ∞ 0
