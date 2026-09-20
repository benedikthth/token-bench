s←⍞
out←''
:If 0<≢s
    c←⊃s ⋄ n←1
    :For ch :In 1↓s
        :If ch≡c
            n←n+1
        :Else
            out,←c,⍕n
            c←ch ⋄ n←1
        :EndIf
    :EndFor
    out,←c,⍕n
:EndIf
⎕←out
