t←⎕C⊃⎕NGET'/dev/stdin'
w←(t∊⎕C⎕A)⊆t
:If 0<≢w
    u←∪w
    c←{≢⍵}⌸w
    i←⍋u
    u←u[i]
    c←c[i]
    i←⍒c
    s←∊(u[i]),¨' ',¨(⍕¨c[i]),¨⎕UCS 10
    tn←'/dev/stdout'⎕NTIE 0 1
    s ⎕NAPPEND tn 80
    ⎕NUNTIE tn
:EndIf
