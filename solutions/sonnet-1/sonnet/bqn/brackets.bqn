opens ← "([{"
closes ← ")]}"

Go ← {
  𝕊: # 𝕨: stack (list of open-bracket chars), 𝕩: remaining chars
  0=≠𝕩 ? 0=≠𝕨 ;
  c ← ⊑𝕩
  ⊑c∊opens ? (𝕨∾<c) 𝕊 1↓𝕩 ;
  0=≠𝕨 ? 0 ;
  c ← ⊑𝕩
  ((⊑closes⊐c)⊑opens) = (¯1⊑𝕨) ? (¯1↓𝕨) 𝕊 1↓𝕩 ;
  0
}

Check ← {"no"‿"yes" ⊑˜ ⟨⟩ Go 𝕩}

lines ← •FLines "/dev/stdin"
•Out¨ Check¨ lines
