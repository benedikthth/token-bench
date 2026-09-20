package main

import (
	"bufio"
	"container/heap"
	"os"
	"strconv"
)

type item struct {
	d int64
	v int
}

type pq []item

func (p pq) Len() int            { return len(p) }
func (p pq) Less(i, j int) bool  { return p[i].d < p[j].d }
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
	readInt := func() (int64, bool) {
		var n int64
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
			c, _ = reader.ReadByte()
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

	n64, _ := readInt()
	m64, _ := readInt()
	n, m := int(n64), int(m64)
	head := make([]int, n)
	for i := range head {
		head[i] = -1
	}
	next := make([]int, 0, 2*m)
	to := make([]int, 0, 2*m)
	wt := make([]int64, 0, 2*m)
	add := func(u, v int, w int64) {
		to = append(to, v)
		wt = append(wt, w)
		next = append(next, head[u])
		head[u] = len(to) - 1
	}
	for i := 0; i < m; i++ {
		u, _ := readInt()
		v, _ := readInt()
		w, _ := readInt()
		add(int(u), int(v), w)
		add(int(v), int(u), w)
	}
	s64, _ := readInt()
	t64, _ := readInt()
	s, t := int(s64), int(t64)

	out := bufio.NewWriter(os.Stdout)
	defer out.Flush()

	if s == t {
		out.WriteString("0\n")
		return
	}

	const inf = int64(1) << 62
	dist := make([]int64, n)
	for i := range dist {
		dist[i] = inf
	}
	dist[s] = 0
	h := &pq{{0, s}}
	for h.Len() > 0 {
		cur := heap.Pop(h).(item)
		if cur.d > dist[cur.v] {
			continue
		}
		if cur.v == t {
			break
		}
		for e := head[cur.v]; e != -1; e = next[e] {
			nd := cur.d + wt[e]
			if nd < dist[to[e]] {
				dist[to[e]] = nd
				heap.Push(h, item{nd, to[e]})
			}
		}
	}
	if dist[t] == inf {
		out.WriteString("-1\n")
	} else {
		out.WriteString(strconv.FormatInt(dist[t], 10) + "\n")
	}
}
