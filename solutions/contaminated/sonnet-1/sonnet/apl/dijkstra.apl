⎕IO←0

⍝ Split a line into numbers
Nums←{⍎¨(' '≠⍵)⊆⍵}

∇ d←Dijkstra args;N;adj;s;t;dist;visited;u;v;i;cand;vals;mi;INF
  N←0⊃args ⋄ adj←1⊃args ⋄ s←2⊃args ⋄ t←3⊃args
  INF←100000000
  dist←N⍴INF
  dist[s]←0
  visited←N⍴0
  :For i :In ⍳N
    cand←(~visited)/⍳N
    :If 0=≢cand
      :Leave
    :EndIf
    vals←dist[cand]
    mi←⌊/vals
    u←⊃(vals=mi)/cand
    :If dist[u]=INF
      :Leave
    :EndIf
    visited[u]←1
    :For v :In ⍳N
      :If (~visited[v])∧(adj[u;v]<INF)
        :If (dist[u]+adj[u;v])<dist[v]
          dist[v]←dist[u]+adj[u;v]
        :EndIf
      :EndIf
    :EndFor
  :EndFor
  d←dist[t]
∇

lines←⊃⎕NGET '/dev/stdin' 1
lines←{(⍵≠⎕UCS 13)/⍵}¨lines        ⍝ strip stray CR
lines←(0<≢¨lines)/lines            ⍝ drop empty lines

nm←Nums ⊃lines[0]
N←0⊃nm ⋄ M←1⊃nm
INF←100000000
adj←(N,N)⍴INF

:For i :In ⍳M
  e←Nums ⊃lines[1+i]
  u←0⊃e ⋄ v←1⊃e ⋄ w←2⊃e
  :If w<adj[u;v]
    adj[u;v]←w
    adj[v;u]←w
  :EndIf
:EndFor

st←Nums ⊃lines[1+M]
s←0⊃st ⋄ t←1⊃st

:If s=t
  ⎕←0
:Else
  d←Dijkstra (N adj s t)
  :If d≥INF
    ⎕←'-1'
  :Else
    ⎕←d
  :EndIf
:EndIf
