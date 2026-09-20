package main

import (
	"bufio"
	"fmt"
	"os"
)

func isBalanced(line string) bool {
	stack := make([]byte, 0, len(line))
	pairs := map[byte]byte{')': '(', ']': '[', '}': '{'}
	for i := 0; i < len(line); i++ {
		c := line[i]
		switch c {
		case '(', '[', '{':
			stack = append(stack, c)
		case ')', ']', '}':
			if len(stack) == 0 || stack[len(stack)-1] != pairs[c] {
				return false
			}
			stack = stack[:len(stack)-1]
		}
	}
	return len(stack) == 0
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	writer := bufio.NewWriter(os.Stdout)
	defer writer.Flush()

	for scanner.Scan() {
		line := scanner.Text()
		if isBalanced(line) {
			fmt.Fprintln(writer, "yes")
		} else {
			fmt.Fprintln(writer, "no")
		}
	}
}
