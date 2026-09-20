#!/usr/bin/env bqn

# Scan ahead while condition is true
ScanWhile ← {
  cond ← 𝕨
  start ← 𝕩
  Loop ← {
    p ← 𝕩
    cond p ? Loop p+1 : p
  }
  Loop start
}

# Tokenize
Tokenize ← {
  s ← (𝕩≠' ')/𝕩

  TokLoop ← {
    state ← 𝕩
    toks ← state[0]
    pos ← state[1]
    Done ← pos ≥ ≠s
    Done ? toks :
      c ← s[pos]
      IsDigit ← ('0'≤c) ∧ (c≤'9')
      IsDigit ? (
        IsD ← {p ← 𝕩 ⋄ p < ≠s ∧ ('0'≤s[p]) ∧ (s[p]≤'9')}
        end_p ← ScanWhile IsD pos
        num ← •ParseFloat (s[pos..end_p-1])
        TokLoop ⟨toks ∾ ⟨num⟩, end_p⟩
      ) :
        TokLoop ⟨toks ∾ ⟨c⟩, pos + 1⟩
  }

  TokLoop ⟨⟨⟩, 0⟩
}

# Parse expression with operator precedence
ParseFactor ← {
  tokens ← 𝕨
  pos ← 𝕩
  token ← tokens[pos]
  IsParen ← token = '('
  IsParen ? (
    res ← tokens ParseExpr (pos+1)
    ⟨res[0], res[1]+1⟩
  ) :
    ⟨token, pos+1⟩
}

ParseTerm ← {
  tokens ← 𝕨
  pos ← 𝕩
  res ← tokens ParseFactor pos
  left ← res[0]
  p ← res[1]

  Loop ← {
    state ← 𝕩
    l ← state[0]
    p ← state[1]
    HasOp ← (p < ≠tokens) ∧ (('*'=tokens[p]) ∨ ('/'=tokens[p]))
    HasOp ? (
      op ← tokens[p]
      res ← tokens ParseFactor (p+1)
      r ← res[0]
      np ← res[1]
      new_l ← op='*' ? l×r : l÷r
      Loop ⟨new_l, np⟩
    ) :
      state
  }

  Loop ⟨left, p⟩
}

ParseExpr ← {
  tokens ← 𝕨
  pos ← 𝕩
  res ← tokens ParseTerm pos
  left ← res[0]
  p ← res[1]

  Loop ← {
    state ← 𝕩
    l ← state[0]
    p ← state[1]
    HasOp ← (p < ≠tokens) ∧ (('+'=tokens[p]) ∨ ('-'=tokens[p]))
    HasOp ? (
      op ← tokens[p]
      res ← tokens ParseTerm (p+1)
      r ← res[0]
      np ← res[1]
      new_l ← op='+' ? l+r : l-r
      Loop ⟨new_l, np⟩
    ) :
      state
  }

  Loop ⟨left, p⟩
}

Eval ← {
  tokens ← Tokenize 𝕩
  res ← tokens ParseExpr 0
  res[0]
}

{•Show Eval 𝕩} ¨ •FLines ""
