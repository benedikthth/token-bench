Encode ← {
  𝕊 s:
  0=≠s ? "" ;
  b ← 1∾(1↓s)≠¯1↓s
  gid ← +`b
  groups ← (gid-1)⊔s
  chars ← 1⊸↑¨groups
  counts ← •Fmt¨≠¨groups
  ∾ chars∾¨counts
}

lines ← •FLines "/dev/stdin"
s ← {0=≠𝕩 ? "" ; ⊑𝕩} lines

•Out (Encode s)
