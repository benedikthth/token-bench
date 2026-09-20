⍝ Shortest path (Dijkstra) solution

Nums←{⍎¨(⍵≠' ')⊆⍵}
Trim←{(⌽∨\⌽⍵≠' ')/⍵}

∇ Main
  ⍝ read all lines of stdin
  raw←↓⊃⎕NGET '/dev/stdin' 2
  raw←Trim¨{(⍵≠⎕UCS 13)/⍵}¨raw

  hdr←Nums ⊃raw[1]
  N←hdr[1] ⋄ M←hdr[2]

  INF←999999999
  W←(N,N)⍴INF

  :For i :In ⍳M
    e←Nums ⊃raw[1+i]
    u←e[1]+1 ⋄ v←e[2]+1 ⋄ w←e[3]
    W[u;v]←w⌊W[u;v]
    W[v;u]←w⌊W[v;u]
  :EndFor

  st←Nums ⊃raw[2+M]
  s←st[1]+1 ⋄ t←st[2]+1

  dist←N⍴INF
  dist[s]←0
  visited←N⍴0
  INF2←INF×N+1

  :For k :In ⍳N
    cand←dist+visited×INF2
    mv←⌊/cand
    :If mv≥INF2
      :Leave
    :EndIf
    u←cand⍳mv
    visited[u]←1
    :For v :In ⍳N
      :If (~visited[v])∧(W[u;v]<INF)
        nd←dist[u]+W[u;v]
        :If nd<dist[v]
          dist[v]←nd
        :EndIf
      :EndIf
    :EndFor
  :EndFor

  :If dist[t]<INF
    ⎕←dist[t]
  :Else
    ⎕←'-1'
  :EndIf
∇

Main
