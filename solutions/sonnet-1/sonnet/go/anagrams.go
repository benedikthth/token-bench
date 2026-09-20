package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
)

func sortedKey(s string) string {
	b := []byte(s)
	sort.Slice(b, func(i, j int) bool { return b[i] < b[j] })
	return string(b)
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Buffer(make([]byte, 1024*1024), 1024*1024)

	groups := make(map[string][]string)
	var keys []string

	for scanner.Scan() {
		word := scanner.Text()
		if word == "" {
			continue
		}
		key := sortedKey(word)
		if _, ok := groups[key]; !ok {
			keys = append(keys, key)
		}
		groups[key] = append(groups[key], word)
	}

	type group struct {
		first string
		words []string
	}
	var result []group
	for _, key := range keys {
		words := groups[key]
		sort.Strings(words)
		result = append(result, group{first: words[0], words: words})
	}

	sort.Slice(result, func(i, j int) bool { return result[i].first < result[j].first })

	writer := bufio.NewWriter(os.Stdout)
	defer writer.Flush()
	for _, g := range result {
		line := ""
		for i, w := range g.words {
			if i > 0 {
				line += " "
			}
			line += w
		}
		fmt.Fprintln(writer, line)
	}
}
