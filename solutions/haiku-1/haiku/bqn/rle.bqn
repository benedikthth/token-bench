Encode ← {
  0 < ≠𝕩 ? {
    input ← 𝕩
    Process ← {𝕩 ≥ ≠input ? "" ⊣ {char ← input ⊏ 𝕩 ⋄ count ← +´ char = input ⊏ (𝕩 + ↕ (≠input - 𝕩)) ⋄ char ∾ •Fmt count ∾ Process (𝕩 + count)}}
    Process 0
  } ⊣ ""
}

•Out Encode •GetLine ""
