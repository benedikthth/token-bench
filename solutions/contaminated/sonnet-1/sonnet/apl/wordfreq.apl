lines←⊃⎕NGET '/dev/stdin' 1
:If 0=≢lines
    text←''
:Else
    text←∊{⍵,' '}¨lines
:EndIf
codes←⎕UCS text
upperMask←(codes≥65)∧(codes≤90)
lowerMask←(codes≥97)∧(codes≤122)
letterMask←upperMask∨lowerMask
codes←codes+32×upperMask
text←⎕UCS codes
words←letterMask⊆text
:If 0<≢words
    uw←∪words
    cnt←+/uw∘.≡words
    sIdx←⍋uw
    uw←uw[sIdx] ⋄ cnt←cnt[sIdx]
    fIdx←⍋-cnt
    uw←uw[fIdx] ⋄ cnt←cnt[fIdx]
    out←{uw[⍵],' ',⍕cnt[⍵]}¨⍳≢uw
    ⎕←∊{⍵,⎕UCS 10}¨out
:EndIf
