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

	// Read all input and count words
	wordCount := make(map[string]int)

	for scanner.Scan() {
		line := scanner.Text()
		words := extractWords(line)
		for _, word := range words {
			wordCount[word]++
		}
	}

	// Create a slice of word-count pairs
	type wordCountPair struct {
		word  string
		count int
	}

	pairs := make([]wordCountPair, 0, len(wordCount))
	for word, count := range wordCount {
		pairs = append(pairs, wordCountPair{word, count})
	}

	// Sort by count descending, then by word ascending
	sort.Slice(pairs, func(i, j int) bool {
		if pairs[i].count != pairs[j].count {
			return pairs[i].count > pairs[j].count
		}
		return pairs[i].word < pairs[j].word
	})

	// Print results
	for _, p := range pairs {
		fmt.Printf("%s %d\n", p.word, p.count)
	}
}

func extractWords(text string) []string {
	var words []string
	var currentWord strings.Builder

	for _, r := range text {
		// Check if it's an ASCII letter (A-Z or a-z)
		if (r >= 'A' && r <= 'Z') || (r >= 'a' && r <= 'z') {
			// Convert to lowercase
			if r >= 'A' && r <= 'Z' {
				currentWord.WriteRune(r + 32)
			} else {
				currentWord.WriteRune(r)
			}
		} else {
			// Non-letter character ends the current word
			if currentWord.Len() > 0 {
				words = append(words, currentWord.String())
				currentWord.Reset()
			}
		}
	}

	// Don't forget the last word
	if currentWord.Len() > 0 {
		words = append(words, currentWord.String())
	}

	return words
}
