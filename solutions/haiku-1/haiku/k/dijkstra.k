/ Read input
inp: 0:"";

/ Parse first line (N nodes, M edges)
N M: "I"$" "split inp[0];

/ Build adjacency list
adj: N#(0#0);
{
  parts: " "split inp[1+x];
  u: "I"$parts[0];
  v: "I"$parts[1];
  w: "I"$parts[2];
  adj[u]: adj[u], ,(v, w);
  adj[v]: adj[v], ,(u, w);
} each !M;

/ Parse query
s t: "I"$" "split inp[1+M];

/ Special case: source equals target
if[s = t; `0: "0"; :()];

/ Dijkstra's algorithm
INF: 2000000000;
dist: N#INF;
dist[s]: 0;
visited: N#0;

/ Main iteration - run N times
{
  / Find unvisited node with minimum distance
  min_u: -1;
  min_d: INF;
  {
    if[visited[x] = 0;
      if[dist[x] < min_d;
        min_d: dist[x];
        min_u: x;
      ];
    ];
  } each !N;

  / If no reachable unvisited node found, stop
  if[min_u = -1; :()];

  / Mark node as visited
  visited[min_u]: 1;

  / Relax all edges from this node
  {
    v: x[0];
    w: x[1];
    if[dist[min_u] + w < dist[v];
      dist[v]: dist[min_u] + w;
    ];
  } each adj[min_u];
} each !N;

/ Output result
if[dist[t] = INF;
  `0: "-1";
  :()
];
`0: string dist[t];
