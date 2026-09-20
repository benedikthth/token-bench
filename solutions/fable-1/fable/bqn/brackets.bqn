# Balanced brackets: one line of input → "yes" or "no"

# Process one character c against accumulator ⟨ok, stack⟩
Step ← { c 𝕊 ok‿st:
  o    ← ⊑"([{"⊐⋈c    # opening index, 3 if not an opener
  cl   ← ⊑")]}"⊐⋈c    # closing index, 3 if not a closer
  top  ← ⊑(⌽st)∾3     # top of stack, 3 if empty
  push ← o<3
  pop  ← (cl<3) ∧ cl=top
  ⟨ok ∧ push∨pop, (-pop) ↓ st ∾ push/⋈o⟩
}

Bal ← { ok‿st ← ⟨1, ⟨⟩⟩ Step´ ⌽𝕩 ⋄ ok ∧ 0=≠st }

lines ← {𝕩/˜𝕩≠@+13}¨ •FLines "/dev/stdin"
•Out¨ "no"‿"yes" ⊏˜ Bal¨ lines
