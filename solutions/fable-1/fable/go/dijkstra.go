package main

import (
	"bufio"
	"container/heap"
	"fmt"
	"os"
	"strconv"
)

type edge struct {
	to int
	w  int64
}

type item struct {
	node int
	dist int64
}

type pq []item

func (p pq) Len() int            { return len(p) }
func (p pq) Less(i, j int) bool  { return p[i].dist < p[j].dist }
func (p pq) Swap(i, j int)       { p[i], p[j] = p[j], p[i] }
func (p *pq) Push(x interface{}) { *p = append(*p, x.(item)) }
func (p *pq) Pop() interface{} {
	old := *p
	n := len(old)
	x := old[n-1]
	*p = old[:n-1]
	return x
}

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)
	writer := bufio.NewWriter(os.Stdout)
	defer writer.Flush()

	readInt := func() (int64, bool) {
		n := int64(0)
		c, err := reader.ReadByte()
		for err == nil && (c == ' ' || c == '\n' || c == '\r' || c == '\t') {
			c, err = reader.ReadByte()
		}
		if err != nil {
			return 0, false
		}
		neg := false
		if c == '-' {
			neg = true
			c, err = reader.ReadByte()
			if err != nil {
				return 0, false
			}
		}
		for err == nil && c >= '0' && c <= '9' {
			n = n*10 + int64(c-'0')
			c, err = reader.ReadByte()
		}
		if neg {
			n = -n
		}
		return n, true
	}

	nn, ok := readInt()
	if !ok {
		return
	}
	mm, _ := readInt()
	n := int(nn)
	m := int(mm)

	adj := make([][]edge, n)
	for i := 0; i < m; i++ {
		u, _ := readInt()
		v, _ := readInt()
		w, _ := readInt()
		if u < 0 || v < 0 || int(u) >= n || int(v) >= n {
			continue
		}
		adj[u] = append(adj[u], edge{int(v), w})
		adj[v] = append(adj[v], edge{int(u), w})
	}
	ss, _ := readInt()
	tt, _ := readInt()
	s := int(ss)
	t := int(tt)

	if s == t {
		fmt.Fprintln(writer, 0)
		return
	}
	if s < 0 || s >= n || t < 0 || t >= n {
		fmt.Fprintln(writer, -1)
		return
	}

	const inf = int64(1) << 62
	dist := make([]int64, n)
	for i := range dist {
		dist[i] = inf
	}
	dist[s] = 0
	h := &pq{{s, 0}}
	for h.Len() > 0 {
		cur := heap.Pop(h).(item)
		if cur.dist > dist[cur.node] {
			continue
		}
		if cur.node == t {
			break
		}
		for _, e := range adj[cur.node] {
			nd := cur.dist + e.w
			if nd < dist[e.to] {
				dist[e.to] = nd
				heap.Push(h, item{e.to, nd})
			}
		}
	}
	if dist[t] == inf {
		fmt.Fprintln(writer, -1)
	} else {
		fmt.Fprintln(writer, strconv.FormatInt(dist[t], 10))
	}
}
