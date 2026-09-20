s←⍞
s←(s∊⎕A,⎕C ⎕A)/s
:If 0=≢s
    ⎕←''
:Else
    b←1,2≠/s
    r←b⊂s
    ⎕←∊(⊃¨r),¨⍕¨≢¨r
:EndIf
