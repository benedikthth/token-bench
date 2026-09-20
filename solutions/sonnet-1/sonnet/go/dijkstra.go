package main

import (
	"bufio"
	"container/heap"
	"fmt"
	"os"
)

type edge struct {
	to int
	w  int
}

type item struct {
	node int
	dist int
}

type priorityQueue []item

func (pq priorityQueue) Len() int            { return len(pq) }
func (pq priorityQueue) Less(i, j int) bool  { return pq[i].dist < pq[j].dist }
func (pq priorityQueue) Swap(i, j int)       { pq[i], pq[j] = pq[j], pq[i] }
func (pq *priorityQueue) Push(x interface{}) { *pq = append(*pq, x.(item)) }
func (pq *priorityQueue) Pop() interface{} {
	old := *pq
	n := len(old)
	it := old[n-1]
	*pq = old[:n-1]
	return it
}

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)

	var n, m int
	if _, err := fmt.Fscan(reader, &n, &m); err != nil {
		return
	}

	adj := make([][]edge, n)
	for i := 0; i < m; i++ {
		var u, v, w int
		fmt.Fscan(reader, &u, &v, &w)
		adj[u] = append(adj[u], edge{v, w})
		adj[v] = append(adj[v], edge{u, w})
	}

	var s, t int
	fmt.Fscan(reader, &s, &t)

	if s == t {
		fmt.Println(0)
		return
	}

	const inf = int(1) << 62
	dist := make([]int, n)
	for i := range dist {
		dist[i] = inf
	}
	dist[s] = 0

	pq := &priorityQueue{{node: s, dist: 0}}
	heap.Init(pq)

	visited := make([]bool, n)

	for pq.Len() > 0 {
		cur := heap.Pop(pq).(item)
		if visited[cur.node] {
			continue
		}
		visited[cur.node] = true

		if cur.node == t {
			break
		}

		for _, e := range adj[cur.node] {
			nd := cur.dist + e.w
			if nd < dist[e.to] {
				dist[e.to] = nd
				heap.Push(pq, item{e.to, nd})
			}
		}
	}

	if dist[t] >= inf {
		fmt.Println(-1)
	} else {
		fmt.Println(dist[t])
	}
}
