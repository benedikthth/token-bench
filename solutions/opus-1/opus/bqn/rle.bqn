s ← •GetLine@
s ↩ (@≡s)⊑⟨s,""⟩
s ↩ (∊⟜"abcdefghijklmnopqrstuvwxyz" s)/s
i ← / s≠»s
l ← (1↓i∾≠s) - i
•Out ""∾∾ (i⊏s) {𝕨∾•Fmt 𝕩}¨ l
