package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	counts := make(map[string]int)

	var sb strings.Builder
	flush := func() {
		if sb.Len() > 0 {
			counts[sb.String()]++
			sb.Reset()
		}
	}

	for {
		r, _, err := reader.ReadRune()
		if err != nil {
			break
		}
		if r >= 'a' && r <= 'z' {
			sb.WriteRune(r)
		} else if r >= 'A' && r <= 'Z' {
			sb.WriteRune(r - 'A' + 'a')
		} else {
			flush()
		}
	}
	flush()

	words := make([]string, 0, len(counts))
	for w := range counts {
		words = append(words, w)
	}

	sort.Slice(words, func(i, j int) bool {
		if counts[words[i]] != counts[words[j]] {
			return counts[words[i]] > counts[words[j]]
		}
		return words[i] < words[j]
	})

	w := bufio.NewWriter(os.Stdout)
	defer w.Flush()
	for _, word := range words {
		fmt.Fprintf(w, "%s %d\n", word, counts[word])
	}
}
