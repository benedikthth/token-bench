lines: ()
{lines: lines, enlist x} each 0:

nm: `I$ " " vs lines[0]
n: nm[0]
m: nm[1]

edges: {`I$ " " vs lines[x]} each 1 + til m

st: `I$ " " vs lines[1 + m]
s: st[0]
t: st[1]

if[s = t; :0]

adj: n # enlist ()
{
  u: edges[x; 0]
  v: edges[x; 1]
  w: edges[x; 2]
  adj[u]: adj[u], enlist (v; w)
  adj[v]: adj[v], enlist (u; w)
} each til m

dist: (n # 1e308)
dist[s]: 0
visited: n # 0b

{
  unvisited: where visited = 0b
  if[0 = #unvisited; :0]

  unvisited_dist: dist[unvisited]
  min_pos: ?min unvisited_dist
  u: unvisited[min_pos]

  if[dist[u] = 1e308; :0]

  visited[u]: 1b

  {
    v: x[0]
    w: x[1]
    new_dist: dist[u] + w
    if[new_dist < dist[v]; dist[v]: new_dist]
  } each adj[u]
} each til n

if[dist[t] = 1e308; -1; dist[t]]
