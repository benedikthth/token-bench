lines←⊃⎕NGET '/dev/stdin' 1
lines←{⍵~⎕UCS 13 10 32}¨lines
lines←lines~⊂''
:If 0<≢lines
    keys←{⍵[⍋⍵]}¨lines
    groups←keys{⊂⍵[⍋↑⍵]}⌸lines
    groups←groups[⍋↑⊃¨groups]
    ⎕←1↓∊(⎕UCS 10),¨{1↓∊' ',¨⍵}¨groups
:EndIf
