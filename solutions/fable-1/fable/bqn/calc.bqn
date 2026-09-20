dig ← "0123456789"

# Tokenize: numbers become numbers, operators/parens stay as characters
Tok ← {𝕊 s:
  s ↩ (s∊dig∾"+-*/()")/s
  d ← s∊dig
  st ← (¬d) ∨ d ∧ ¬»d
  g ← ((+`st)-1) ⊔ s
  {⊑(⊑𝕩)∊dig ? +⟜(10⊸×)´⌽𝕩-'0' ; ⊑𝕩}¨ g
}

# Recursive-descent evaluation of a token list
Eval ← {𝕊 t:
  i ← 0
  Peek ← {𝕤 ⋄ i<≠t ? i⊑t ; @}
  Next ← {𝕤 ⋄ r←i⊑t ⋄ i+↩1 ⋄ r}
  Div ← {(×𝕨×𝕩)×⌊(|𝕨)÷|𝕩}
  Atom ← {𝕤
    '('≡Peek@ ? Next@ ⋄ v←Expr@ ⋄ Next@ ⋄ v ;
    Next@
  }
  Term ← {𝕤
    v ← Atom@
    L ← {𝕤
      ⊑(Peek@)∊"*/" ? o←Next@ ⋄ a←Atom@ ⋄ v ↩ v {o='*' ? 𝕨×𝕩 ; 𝕨 Div 𝕩} a ⋄ L@ ;
      v
    }
    L@
  }
  Expr ← {𝕤
    v ← Term@
    L ← {𝕤
      ⊑(Peek@)∊"+-" ? o←Next@ ⋄ a←Term@ ⋄ v ↩ v {o='+' ? 𝕨+𝕩 ; 𝕨-𝕩} a ⋄ L@ ;
      v
    }
    L@
  }
  Expr@
}

Fmt ← {((𝕩<0)/"-") ∾ •Repr |𝕩}

lines ← •file.Lines "/dev/stdin"
{
  t ← Tok 𝕩
  0<≠t ? •Out Fmt Eval t ; @
}¨ lines
