Pop ← {0=≠𝕩 ? 𝕩∾'x' ; 𝕨=¯1⊑𝕩 ? ¯1↓𝕩 ; 𝕩∾'x'}
Close ← {(⊑"([{x"⊏˜")]}"⊐⋈𝕨) Pop 𝕩}
Step ← {∨´𝕨="([{" ? 𝕩∾𝕨 ; ∨´𝕨=")]}" ? 𝕨 Close 𝕩 ; 𝕩}
Bal ← {0=≠"" Step´ ⌽𝕩}
Loop ← {
  @≡𝕩 ? @ ;
  •Out (Bal 𝕩)⊑"no"‿"yes"
  𝕊 •GetLine @
}
Loop •GetLine @
