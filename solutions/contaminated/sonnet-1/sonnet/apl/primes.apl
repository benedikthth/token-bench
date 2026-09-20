⎕IO←0
lines←⊃⎕NGET '/dev/stdin' 1
n←⊃⍎¨(0<≢¨lines)/lines

:If n<2
    ⎕←''
:Else
    sieve←(n+1)⍴1
    sieve[0 1]←0 0
    i←2
    :While (i×i)≤n
        :If sieve[i]
            sieve[(i×i)+i×⍳1+⌊(n-i×i)÷i]←0
        :EndIf
        i←i+1
    :EndWhile
    primes←⍸sieve
    ⎕←1↓∊' ',¨⍕¨primes
:EndIf
