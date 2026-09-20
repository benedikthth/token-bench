big ← 1000000000000
big2 ← 10000000000000

lines ← •FLines "/dev/stdin"
header ← •BQN (0⊑lines)
n ← 0⊑header
m ← 1⊑header
edges ← •BQN¨ (m↑1↓lines)
st ← •BQN ((m+1)⊑lines)
s ← 0⊑st
t ← 1⊑st

mat0 ← n‿n⥊big

BuildMat ← {
  (1⊑𝕩)≥m ? 0⊑𝕩 ;
  mat‿i ← 𝕩
  a‿b‿w ← i⊑edges
  cur ← a‿b⊑mat
  v ← w⌊cur
  mat1 ← v⊸⊢⌾(a‿b⊸⊑) mat
  mat2 ← v⊸⊢⌾(b‿a⊸⊑) mat1
  𝕊 mat2‿(i+1)
}
mat ← BuildMat mat0‿0

dinit ← n⥊big
d0 ← 0⊸⊢⌾(s⊸⊑) dinit
visited0 ← n⥊0

DijkstraLoop ← {
  (2⊑𝕩)=0 ? 0⊑𝕩 ;
  d‿visited‿remaining ← 𝕩
  masked ← d + visited×big2
  minval ← ⌊´masked
  u ← masked⊐minval
  visited2 ← 1⊸⊢⌾(u⊸⊑) visited
  row ← u⊏mat
  cand ← row + (u⊑d)
  d2 ← d⌊cand
  𝕊 d2‿visited2‿(remaining-1)
}

finald ← DijkstraLoop d0‿visited0‿n

ans ← t⊑finald

{(ans=big) ? •Out "-1" ; •Out •Fmt ans}
