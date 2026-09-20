# Balanced brackets
# Remove one layer of adjacent pairs "()", "[]", "{}"
Reduce ← ▽⊸(=0⦷"{}")▽⊸(=0⦷"[]")▽⊸(=0⦷"()")
# Strip line endings, reduce to a fixed point, balanced iff nothing remains
Bal ← =0⧻ ⍢(Reduce|≠⊃(⧻Reduce)⧻⟜∘) ▽⊸≠@\r ▽⊸≠@\n
# Split into lines (each line keeps its trailing newline, so empty lines survive)
Lines ← ⊕□ \+⊂0↘¯1 ⊸=@\n
≡(&p °□ ˜⊏ {"no" "yes"} Bal °□) Lines &fras "/dev/stdin"
