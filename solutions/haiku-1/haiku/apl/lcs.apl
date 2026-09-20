s1 ← ⍞
s2 ← ⍞

n1 ← ≢s1
n2 ← ≢s2

dp ← (n1+1) (n2+1) ⍴ 0

:For i :In ⍳n1
    :For j :In ⍳n2
        :If s1[i] = s2[j]
            dp[i+1;j+1] ← dp[i;j] + 1
        :Else
            dp[i+1;j+1] ← (dp[i;j+1]) ⌈ (dp[i+1;j])
        :EndIf
    :EndFor
:EndFor

⎕ ← dp[n1+1;n2+1]
