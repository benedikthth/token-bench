⎕IO←0
⎕PP←17

⍝ Truncate toward zero
Trunc←{(×⍵)×⌊|⍵}

⍝ s SkipSp p → next non-space position at or after p
SkipSp←{
  s←⍺ ⋄ p←⍵
  rest←p↓s
  mask←rest=' '
  len←⊃(⍸~mask),≢rest
  p+len
}

⍝ s ParseNumber p → (p v) after consuming a run of digits starting at p
ParseNumber←{
  s←⍺ ⋄ p←⍵
  rest←p↓s
  mask←rest∊⎕D
  len←⊃(⍸~mask),≢rest
  v←⍎len↑rest
  (p+len) v
}

⍝ s FactorParen p → (p v) : consumes '(' expr ')' ; p points just after '('
FactorParen←{
  s←⍺ ⋄ p←⍵
  p←s SkipSp p
  r←s ParseExpr p
  p←⊃r ⋄ v←⊃⌽r
  p←s SkipSp p
  p←p+1               ⍝ skip ')'
  p v
}

⍝ s ParseFactor p → (p v) : number or ( expr )
ParseFactor←{
  s←⍺ ⋄ p←⍵
  p←s SkipSp p
  (s[p]='('): s FactorParen p+1
  s ParseNumber p
}

⍝ s TermStep (p v) → (p v) : consumes one (* or /) factor and continues
TermStep←{
  s←⍺ ⋄ p←⊃⍵ ⋄ v←⊃⌽⍵
  p2←s SkipSp p+1
  r2←s ParseFactor p2
  p3←⊃r2 ⋄ v2←⊃⌽r2
  (s[p]='*'): s TermLoop (p3 (v×v2))
  s TermLoop (p3 (Trunc v÷v2))
}

⍝ s TermLoop (p v) → (p v) : consumes (* / factor)* while present
TermLoop←{
  s←⍺ ⋄ p←⊃⍵ ⋄ v←⊃⌽⍵
  p←s SkipSp p
  p≥≢s: p v
  (s[p]='*')∨(s[p]='/'): s TermStep (p v)
  p v
}

⍝ s ParseTerm p → (p v) : factor ((* /) factor)*
ParseTerm←{
  s←⍺ ⋄ p←⍵
  r←s ParseFactor p
  s TermLoop r
}

⍝ s ExprStep (p v) → (p v) : consumes one (+ or -) term and continues
ExprStep←{
  s←⍺ ⋄ p←⊃⍵ ⋄ v←⊃⌽⍵
  p2←s SkipSp p+1
  r2←s ParseTerm p2
  p3←⊃r2 ⋄ v2←⊃⌽r2
  (s[p]='+'): s ExprLoop (p3 (v+v2))
  s ExprLoop (p3 (v-v2))
}

⍝ s ExprLoop (p v) → (p v) : consumes (+ - term)* while present
ExprLoop←{
  s←⍺ ⋄ p←⊃⍵ ⋄ v←⊃⌽⍵
  p←s SkipSp p
  p≥≢s: p v
  (s[p]='+')∨(s[p]='-'): s ExprStep (p v)
  p v
}

⍝ s ParseExpr p → (p v) : term ((+ -) term)*
ParseExpr←{
  s←⍺ ⋄ p←⍵
  r←s ParseTerm p
  s ExprLoop r
}

lines←⊃⎕NGET '/dev/stdin' 1
lines←{(⍵≠⎕UCS 13)/⍵}¨lines        ⍝ strip stray CR
lines←(0<≢¨lines)/lines            ⍝ drop empty lines
results←{⊃⌽⍵ ParseExpr 0}¨lines
texts←⍕¨results                    ⍝ format each integer as text
out←1↓∊(⎕UCS 10),¨texts             ⍝ join with LF between lines
out[(out='¯')/⍳≢out]←'-'            ⍝ use ASCII '-' instead of APL high-minus
⎕←out
