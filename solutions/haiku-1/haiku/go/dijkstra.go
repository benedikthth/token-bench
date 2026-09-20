package main

import (
	"bufio"
	"container/heap"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

// Item represents a node with its distance in the priority queue
type Item struct {
	node     int
	distance int
	index    int
}

// PriorityQueue implements heap.Interface
type PriorityQueue []*Item

func (pq PriorityQueue) Len() int { return len(pq) }
func (pq PriorityQueue) Less(i, j int) bool {
	return pq[i].distance < pq[j].distance
}
func (pq PriorityQueue) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
	pq[i].index = i
	pq[j].index = j
}

func (pq *PriorityQueue) Push(x interface{}) {
	n := len(*pq)
	item := x.(*Item)
	item.index = n
	*pq = append(*pq, item)
}

func (pq *PriorityQueue) Pop() interface{} {
	old := *pq
	n := len(old)
	item := old[n-1]
	old[n-1] = nil
	item.index = -1
	*pq = old[0 : n-1]
	return item
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	// Read N and M
	scanner.Scan()
	parts := strings.Fields(scanner.Text())
	n, _ := strconv.Atoi(parts[0])
	m, _ := strconv.Atoi(parts[1])

	// Build adjacency list
	graph := make([][]struct {
		node   int
		weight int
	}, n)

	for i := 0; i < m; i++ {
		scanner.Scan()
		parts := strings.Fields(scanner.Text())
		u, _ := strconv.Atoi(parts[0])
		v, _ := strconv.Atoi(parts[1])
		w, _ := strconv.Atoi(parts[2])

		graph[u] = append(graph[u], struct {
			node   int
			weight int
		}{v, w})
		graph[v] = append(graph[v], struct {
			node   int
			weight int
		}{u, w})
	}

	// Read start and target
	scanner.Scan()
	parts = strings.Fields(scanner.Text())
	s, _ := strconv.Atoi(parts[0])
	t, _ := strconv.Atoi(parts[1])

	// Dijkstra's algorithm with priority queue
	dist := make([]int, n)
	for i := range dist {
		dist[i] = math.MaxInt
	}
	dist[s] = 0

	pq := make(PriorityQueue, 0)
	heap.Push(&pq, &Item{node: s, distance: 0})

	for pq.Len() > 0 {
		current := heap.Pop(&pq).(*Item)
		u := current.node

		// If we've already found a shorter path to this node, skip
		if current.distance > dist[u] {
			continue
		}

		// If we've reached the target, we can return early
		if u == t {
			break
		}

		// Explore neighbors
		for _, edge := range graph[u] {
			v := edge.node
			w := edge.weight
			newDist := dist[u] + w

			if newDist < dist[v] {
				dist[v] = newDist
				heap.Push(&pq, &Item{node: v, distance: newDist})
			}
		}
	}

	if dist[t] == math.MaxInt {
		fmt.Println(-1)
	} else {
		fmt.Println(dist[t])
	}
}
