package main

import (
	"bufio"
	"os"
	"sort"
	"strings"
)

func sortedKey(s string) string {
	b := []byte(s)
	sort.Slice(b, func(i, j int) bool { return b[i] < b[j] })
	return string(b)
}

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)
	writer := bufio.NewWriterSize(os.Stdout, 1<<20)
	defer writer.Flush()

	groups := make(map[string][]string)
	for {
		line, err := reader.ReadString('\n')
		word := strings.TrimRight(line, "\r\n")
		if word != "" {
			key := sortedKey(word)
			groups[key] = append(groups[key], word)
		}
		if err != nil {
			break
		}
	}

	result := make([][]string, 0, len(groups))
	for _, g := range groups {
		sort.Strings(g)
		result = append(result, g)
	}
	sort.Slice(result, func(i, j int) bool {
		if result[i][0] != result[j][0] {
			return result[i][0] < result[j][0]
		}
		return len(result[i]) < len(result[j])
	})

	for _, g := range result {
		writer.WriteString(strings.Join(g, " "))
		writer.WriteByte('\n')
	}
}
