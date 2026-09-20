/ Dijkstra, O(N^2) selection with vectorized relaxation (ngn/k)
x:0:"/dev/stdin"
x:x@&0<#'x
y:.:'x
n:*y[0]
m:y[0][1]
e:1_(m+1)#y
st:y[m+1]
s:*st
t:st[1]
inf:1000000000000000
u:e[;0],e[;1]
v:e[;1],e[;0]
w:e[;2],e[;2]
/ adjacency: edge ids per node; dummy index per node appended then dropped
g:-1_'(=u,!n)@!n
d:@[n#inf;s;:;0]
done:n#0
step:{[st]
 d:st[0];done:st[1]
 k:*<d+inf*done
 $[d[k]<inf
  [ids:g[k];done[k]:1;d:@[d;v ids;&;d[k]+w ids];(d;done)]
  st]}
r:n step/(d;done)
a:r[0][t]
 `0:,$[a<inf;$a;"-1"]
