⎕IO←1
s1←⍞
s2←⍞
m←≢s1 ⋄ n←≢s2
:If (m=0)∨(n=0)
    ans←0
:Else
    prev←n⍴0
    :For i :In ⍳m
        diag←0,prev[⍳n-1]
        match←s2=s1[i]
        candidate←(match×diag+1)+(~match)×prev
        prev←⌈\candidate
    :EndFor
    ans←prev[n]
:EndIf
⎕←ans
