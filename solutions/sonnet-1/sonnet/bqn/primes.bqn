txt ← •FChars "/dev/stdin"
mask ← txt∊"0123456789"
n ← •ParseFloat mask/txt

Primes ← {
  n ← 𝕩
  n<2 ? ⟨⟩ ;
  lim ← ⌊√n
  p ← (n+1)⥊1
  p ↩ {𝕩×0}⌾(0‿1⊸⊏) p
  Mark ← {i‿p ← 𝕩
    cnt ← 0⌈1+⌊(n-i×i)÷i
    pos ← (i×i) + i×↕cnt
    {𝕩×0}⌾(pos⊸⊏) p
  }
  Loop ← {i‿p ← 𝕩
    i>lim ? p ;
    i‿p ← 𝕩
    p ↩ {(i⊑p) ? Mark i‿p ; p}
    Loop (i+1)‿p
  }
  p ↩ Loop 2‿p
  p/↕n+1
}

r ← Primes n
•Out 1↓∾' '∾¨(•Fmt¨r)
