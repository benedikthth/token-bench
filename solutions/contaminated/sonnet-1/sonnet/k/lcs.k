l:0:"/dev/stdin"
a:$[0<#l;l[0];""]
b:$[1<#l;l[1];""]
nb:#b
old:(nb+1)#0
step:{[old;ai]
  match:b=ai;
  cand:(match*(1+(nb#old)))-~match;
  cm:|\cand;
  tail:(1_old)|cm;
  (,0),tail
  }
old:old step/a
`0:,$old[nb]
