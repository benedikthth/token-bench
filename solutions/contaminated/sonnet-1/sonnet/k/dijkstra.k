addEdge:{[W;e]
  u:e 0
  v:e 1
  w:e 2
  w2: w&W[u;v]
  W[u;v]:w2
  W[v;u]:w2
  W
  }
W0:(4;4)#1000000000
e:0 1 1
r:addEdge[W0;e]
`0:,$#r
`0:,$#r 0
`0:,$r[0;1]
`0:,$r[1;0]
`0:,$r[0;0]
