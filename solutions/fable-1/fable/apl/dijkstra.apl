⎕IO←0 ⋄ ⎕PP←17
txt←⊃⎕NGET'/dev/stdin'
txt[⍸txt∊⎕UCS 10 13 9]←' '
nums←⊃⌽⎕VFI txt
N M←2↑nums
E←(M,3)⍴2↓nums
s t←¯2↑nums
BIG←1E18
:If s=t
    ⎕←'0'
:Else
    U←E[;0],E[;1] ⋄ V←E[;1],E[;0] ⋄ W←E[;2],E[;2]
    idx←⍋U ⋄ U←U[idx] ⋄ V←V[idx] ⋄ W←W[idx]
    fin←1+U⍸⍳N
    beg←¯1↓0,fin
    dist←N⍴BIG ⋄ done←N⍴0
    dist[s]←0
    :Repeat
        cand←dist+done×BIG
        m←⌊/cand
        :If m≥BIG ⋄ :Leave ⋄ :EndIf
        u←cand⍳m
        done[u]←1
        :If u=t ⋄ :Leave ⋄ :EndIf
        k←fin[u]-beg[u]
        :If k>0
            ix←beg[u]+⍳k
            nb←V[ix] ⋄ nw←dist[u]+W[ix]
            keys←∪nb
            mins←nb{⌊/⍵}⌸nw
            dist[keys]←dist[keys]⌊mins
        :EndIf
    :EndRepeat
    :If dist[t]≥BIG
        ⎕←'-1'
    :Else
        ⎕←⍕dist[t]
    :EndIf
:EndIf
