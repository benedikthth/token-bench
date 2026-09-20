Fix ← {𝕩='-' ? '¯' ; 𝕩=' ' ? ',' ; 𝕩}
CharFix ← {𝕩='¯' ? '-' ; 𝕩}
ParseInts ← {•BQN ("⟨"∾(Fix¨𝕩)∾"⟩")}
FormatRow ← {1↓∾' '∾¨CharFix¨¨•Fmt¨𝕩}

lines ← •FLines "/dev/stdin"
rc ← ParseInts (0⊑lines)
r ← 0⊑rc
c ← 1⊑rc
rows ← ParseInts¨ (1+↕r)⊏lines
mat ← >rows
t ← ⍉mat
•Out¨ FormatRow¨ ({𝕩⊏t}¨ ↕c)
