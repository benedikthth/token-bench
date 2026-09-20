⍝ Word frequency: words are maximal runs of ASCII letters, compared lowercase.
⍝ Output "word count" sorted by count descending, then word ascending.
:Trap 0
    lines←⊃⎕NGET'/dev/stdin' 1
:Else
    lines←⍬
    :Trap 0
        :Repeat
            lines,←⊂⍞
        :EndRepeat
    :EndTrap
:EndTrap
t←⎕C∊lines,¨⊂' '
m←t∊⎕C ⎕A
w←m⊆t
:If 0<≢w
    u←∪w
    c←{≢⍵}⌸w
    i←⍋↑u
    o←i[⍒c[i]]
    out←∊{(⍵⊃u),' ',(⍕⍵⊃c),⎕UCS 10}¨o
    (⊂out)⎕NPUT'/dev/stdout' 1
:EndIf
