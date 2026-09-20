⎕IO←0

⍝ Convert an integer to its uppercase Roman numeral representation
∇ out←ToRoman n;vals;syms;i;v;s
  vals←1000 900 500 400 100 90 50 40 10 9 5 4 1
  syms←'M' 'CM' 'D' 'CD' 'C' 'XC' 'L' 'XL' 'X' 'IX' 'V' 'IV' 'I'
  out←''
  :For i :In ⍳≢vals
    v←vals[i] ⋄ s←syms[i]
    :While n≥v
      out←out,s
      n←n-v
    :EndWhile
  :EndFor
∇

lines←⊃⎕NGET '/dev/stdin' 1
lines←{(⍵≠⎕UCS 13)/⍵}¨lines        ⍝ strip stray CR
lines←(0<≢¨lines)/lines            ⍝ drop empty lines

:If 0<≢lines
    nums←⍎¨lines
    results←ToRoman¨nums
    out←1↓∊(⎕UCS 10),¨results       ⍝ join with LF between lines
    ⎕←out
:EndIf
