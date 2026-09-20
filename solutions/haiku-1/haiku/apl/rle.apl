s←⊃⎕SH 'head -n 1'
:If 0≠≢s
    result←⊃,/{(⊃⍵),⍕≢⍵}¨(1,(¯1↓s)≠(1↓s))⊂s
:Else
    result←''
:EndIf
⎕ ← result
