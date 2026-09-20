package main

import (
	"bufio"
	"io"
	"os"
	"sort"
	"strconv"
)

func main() {
	data, _ := io.ReadAll(bufio.NewReader(os.Stdin))
	counts := map[string]int{}
	start := -1
	buf := make([]byte, 0, 64)
	for i := 0; i <= len(data); i++ {
		isLetter := false
		if i < len(data) {
			c := data[i]
			isLetter = (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
		}
		if isLetter {
			if start < 0 {
				start = i
				buf = buf[:0]
			}
			c := data[i]
			if c >= 'A' && c <= 'Z' {
				c += 'a' - 'A'
			}
			buf = append(buf, c)
		} else if start >= 0 {
			counts[string(buf)]++
			start = -1
		}
	}
	words := make([]string, 0, len(counts))
	for w := range counts {
		words = append(words, w)
	}
	sort.Slice(words, func(a, b int) bool {
		ca, cb := counts[words[a]], counts[words[b]]
		if ca != cb {
			return ca > cb
		}
		return words[a] < words[b]
	})
	out := bufio.NewWriter(os.Stdout)
	defer out.Flush()
	for _, w := range words {
		out.WriteString(w)
		out.WriteByte(' ')
		out.WriteString(strconv.Itoa(counts[w]))
		out.WriteByte('\n')
	}
}
