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
	counts := make(map[string]int)
	start := -1
	for i := 0; i <= len(data); i++ {
		var c byte
		isLetter := false
		if i < len(data) {
			c = data[i]
			isLetter = (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
		}
		if isLetter {
			if start < 0 {
				start = i
			}
		} else if start >= 0 {
			w := make([]byte, i-start)
			for j := start; j < i; j++ {
				ch := data[j]
				if ch >= 'A' && ch <= 'Z' {
					ch += 'a' - 'A'
				}
				w[j-start] = ch
			}
			counts[string(w)]++
			start = -1
		}
	}

	type entry struct {
		word  string
		count int
	}
	entries := make([]entry, 0, len(counts))
	for w, c := range counts {
		entries = append(entries, entry{w, c})
	}
	sort.Slice(entries, func(a, b int) bool {
		if entries[a].count != entries[b].count {
			return entries[a].count > entries[b].count
		}
		return entries[a].word < entries[b].word
	})

	out := bufio.NewWriter(os.Stdout)
	defer out.Flush()
	for _, e := range entries {
		out.WriteString(e.word)
		out.WriteByte(' ')
		out.WriteString(strconv.Itoa(e.count))
		out.WriteByte('\n')
	}
}
