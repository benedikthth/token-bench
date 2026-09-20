⍝ Simple test - just output the input
all_input ← ⊃⎕SH 'cat'

⍝ Split lines
lines ← ⍬
line ← ''
:For ch :In all_input
    :If ch = ⎕UCS 10
        :If (≢ line) > 0
            lines ← lines, ⊂ line
        :EndIf
        line ← ''
    :Else
        line ← line, ch
    :EndFor
:EndFor
:If (≢ line) > 0
    lines ← lines, ⊂ line
:EndIf

⍝ Output each line
:For l :In lines
    ⎕ ← ⊃ l
:EndFor
