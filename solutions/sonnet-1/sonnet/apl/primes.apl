⎕IO←0
n←⍎⍞
:If n<2
    r←''
:Else
    s←(n+1)⍴1
    s[0 1]←0 0
    p←2
    :While (p×p)≤n
        :If s[p]
            s[(p×p)+p×⍳⌊(n-p×p)÷p]←0
        :EndIf
        p←p+1
    :EndWhile
    primes←,s/⍳n+1
    r←1↓∊' ',¨⍕¨primes
:EndIf
⎕←r
)OFF
