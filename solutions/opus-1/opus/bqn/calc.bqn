Div ← {r ← 𝕨÷𝕩 ⋄ (×r)×⌊|r}
Fmt ← {𝕩<0 ? '-'∾𝕊-𝕩 ; 𝕩<10 ? ⥊'0'+𝕩 ; (𝕊⌊𝕩÷10)∾'0'+10|𝕩}

Eval ← {
  s ← (∊⟜"0123456789+-*/()" 𝕩)/𝕩
  s ∾↩ ";"
  i ← 0
  Prim ← {𝕊:
    c ← i⊑s
    c = '(' ? i +↩ 1 ⋄ v ← Expr @ ⋄ i +↩ 1 ⋄ v ;
    n ← 0
    {𝕊: n ↩ (10×n) + (i⊑s) - '0' ⋄ i +↩ 1} •_while_ {𝕊: ∨´"0123456789"=i⊑s} @
    n
  }
  Term ← {𝕊:
    v ← Prim @
    {𝕊: c ← i⊑s ⋄ i +↩ 1 ⋄ c = '*' ? v ×↩ Prim @ ; v Div↩ Prim @} •_while_ {𝕊: ∨´"*/"=i⊑s} @
    v
  }
  Expr ← {𝕊:
    v ← Term @
    {𝕊: c ← i⊑s ⋄ i +↩ 1 ⋄ c = '+' ? v +↩ Term @ ; v -↩ Term @} •_while_ {𝕊: ∨´"+-"=i⊑s} @
    v
  }
  Expr @
}

lines ← •FLines "/dev/stdin"
{0 < +´ ∊⟜"0123456789" 𝕩 ? •Out Fmt Eval 𝕩 ; @}¨ lines
