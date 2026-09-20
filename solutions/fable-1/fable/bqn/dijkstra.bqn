inp ← •FChars "/dev/stdin"
ws ← inp ∊ " "∾@+9‿10‿13
k ← ¬ws
id ← ¯1 + +` k > »k
toks ← ((id×k)-ws) ⊔ inp
nums ← •ParseFloat¨ toks

n‿m ← 2↑nums
ev ← (3×m) ↑ 2↓nums
u ← (3×↕m)⊏ev
v ← (1+3×↕m)⊏ev
w ← (2+3×↕m)⊏ev
s‿t ← ¯2↑nums

src ← u∾v
dst ← v∾u
wt ← w∾w
adj ← ¯1⊸↓¨ (src∾↕n) ⊔ (↕2×m)∾n⥊¯1

big ← 1e18
dist ← 0⌾(s⊸⊑) n⥊big
vis ← n⥊0

_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}

Cond ← { dist‿vis: (big > ⌊´ (big×vis)⌈dist) ∧ ¬ t⊑vis }
Step ← { dist‿vis:
  cand ← (big×vis)⌈dist
  cu ← ⊑⍋cand
  d ← cu⊑dist
  vis ↩ 1⌾(cu⊸⊑) vis
  es ← cu⊑adj
  nb ← es⊏dst
  c ← d + es⊏wt
  o ← ⍋c
  nb ↩ o⊏nb
  c ↩ o⊏c
  kk ← ∊nb
  nb ↩ kk/nb
  c ↩ kk/c
  dist ↩ (c⊸⌊)⌾(nb⊸⊏) dist
  dist‿vis
}

dist‿vis ↩ Step _while_ Cond dist‿vis

r ← t⊑dist
Digs ← {0=𝕩 ? ⟨⟩ ; (𝕊 ⌊𝕩÷10) ∾ 10|𝕩}
Fmt ← {0=𝕩 ? "0" ; '0'+Digs 𝕩}
•Out (r≥big) ⊑ ⟨Fmt r, "-1"⟩
