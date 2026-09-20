w←⊃⎕NGET'/dev/stdin'1
w←(~¨w∊¨⊂⎕UCS 13 32 9)/¨w
w←(0<≢¨w)/w
:If 0<≢w
    w←w[⍋↑w]
    g←({⍵[⍋⍵]}¨w){⊂⍵}⌸w
    s←∊{(¯1↓∊⍵,¨' '),⎕UCS 10}¨g
    t←'/dev/stdout'⎕NTIE 0
    s ⎕NAPPEND t 80
    ⎕NUNTIE t
:EndIf
