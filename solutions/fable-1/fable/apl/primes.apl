⎕IO←1
n←⊃2⊃⎕VFI(⊃⎕NGET'/dev/stdin')~⎕UCS 10 13
s←(⍳n)≥2
i←2
:While (i×i)≤n
    :If s[i]
        s[(i×i)+i×0,⍳⌊(n-i×i)÷i]←0
    :EndIf
    i+←1
:EndWhile
⎕←1↓∊' ',¨⍕¨⍸s
