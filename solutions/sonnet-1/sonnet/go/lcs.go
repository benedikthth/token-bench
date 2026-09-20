package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func readLine(r *bufio.Reader) string {
	line, err := r.ReadString('\n')
	if err != nil && line == "" {
		return ""
	}
	line = strings.TrimRight(line, "\r\n")
	return line
}

func main() {
	r := bufio.NewReader(os.Stdin)
	a := readLine(r)
	b := readLine(r)

	n := len(a)
	m := len(b)

	prev := make([]int, m+1)
	curr := make([]int, m+1)

	for i := 1; i <= n; i++ {
		for j := 1; j <= m; j++ {
			if a[i-1] == b[j-1] {
				curr[j] = prev[j-1] + 1
			} else if prev[j] >= curr[j-1] {
				curr[j] = prev[j]
			} else {
				curr[j] = curr[j-1]
			}
		}
		prev, curr = curr, prev
	}

	fmt.Println(prev[m])
}
