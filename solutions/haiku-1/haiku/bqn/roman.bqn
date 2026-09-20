ToRoman ← {
  vals ← [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
  nums ← ⟨"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"⟩

  Process ← {
    ⟨num, result⟩ ← 𝕨
    idx ← 𝕩
    val ← vals ⊑ idx
    sym ← nums ⊑ idx
    cnt ← ⌊num ÷ val
    ⟨num - cnt × val, result ∾ (sym × cnt)⟩
  }

  finalPair ← Process´ (↕≠vals) ⊸ ⊑ ⟨𝕩, ""⟩
  finalPair ⊑ 1
}

# Read input line by line
ProcessInput ← {
  line ← •FLine
  line = "" ? · ; (
    •Out ToRoman •BQN line
    ProcessInput
  )
}

ProcessInput
