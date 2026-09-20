package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strings"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	wordGroups := make(map[string][]string)

	// Read words and group by sorted letters
	for scanner.Scan() {
		word := strings.TrimSpace(scanner.Text())
		if word == "" {
			continue
		}

		// Create a key from sorted letters
		sortedChars := strings.Split(word, "")
		sort.Strings(sortedChars)
		key := strings.Join(sortedChars, "")

		wordGroups[key] = append(wordGroups[key], word)
	}

	// Convert to slice for sorting
	type group struct {
		words []string
	}

	var groups []group
	for _, words := range wordGroups {
		sort.Strings(words)
		groups = append(groups, group{words: words})
	}

	// Sort groups by their first word
	sort.Slice(groups, func(i, j int) bool {
		return groups[i].words[0] < groups[j].words[0]
	})

	// Output
	for _, g := range groups {
		fmt.Println(strings.Join(g.words, " "))
	}
}
