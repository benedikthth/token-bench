l ← •GetLine@
s ← (¬∘∊⟜(@+10‿13))⊸/ {0=•Type 𝕩 ? 𝕩 ; ""} l
Rle ← {
  0=≠𝕩 ? "" ;
  st ← 1∾(1↓𝕩)≠(¯1↓𝕩)
  ls ← st/𝕩
  ix ← st/↕≠𝕩
  cnt ← (1↓ix∾≠𝕩) - ix
  ∾ ls {𝕨∾•Repr 𝕩}¨ cnt
}
•Out Rle s
