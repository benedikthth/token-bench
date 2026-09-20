b ← •FChars "/dev/stdin"
dg ← (b≥'0')∧b≤'9'
id ← dg × +`dg∧¬0∾¯1↓dg
nums ← {(10⊸×⊸+)˜´⌽𝕩}¨ (id-1) ⊔ b-'0'
n‿m ← 2↑nums
s‿t ← ¯2↑nums
e ← ⍉ m‿3 ⥊ (3×m)↑2↓nums
u0‿v0‿w0 ← <˘e
u ← u0∾v0 ⋄ v ← v0∾u0 ⋄ w ← w0∾w0
o ← ⍋u
u‿v‿w ↩ o⊸⊏¨ u‿v‿w
cnt ← n↑/⁼u
st ← (+`cnt)-cnt
d ← 0⌾(s⊸⊑) n⥊∞
f ← ⟨s⟩
{𝕤
  c ← f⊏cnt
  ps ← +`c
  ei ← (c/f⊏st) + (↕+´c) - c/ps-c
  tv ← ei⊏v
  nd ← (c/f⊏d) + ei⊏w
  k ← nd < tv⊏d
  tv ↩ k/tv ⋄ nd ↩ k/nd
  g ← ⍋nd
  tv ↩ g⊏tv ⋄ nd ↩ g⊏nd
  k ↩ ∊tv
  tv ↩ k/tv ⋄ nd ↩ k/nd
  d ↩ nd⌾(tv⊸⊏) d
  f ↩ tv
}•_while_{𝕤⋄0<≠f} @
r ← t⊑d
•Out {∞=r ? "-1" ; •Fmt r}
