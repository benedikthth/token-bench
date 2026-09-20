package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	if scanner.Scan() {
		line := scanner.Text()

		var result string
		for i := 0; i < len(line); {
			char := line[i]
			count := 1

			// Count consecutive occurrences of the same character
			for i+count < len(line) && line[i+count] == char {
				count++
			}

			result += fmt.Sprintf("%c%d", char, count)
			i += count
		}

		fmt.Println(result)
	}
}
