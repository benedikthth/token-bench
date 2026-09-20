package main

import (
	"bufio"
	"fmt"
	"os"
)

func isBalanced(line string) bool {
	stack := []rune{}

	for _, char := range line {
		switch char {
		case '(', '[', '{':
			// Push opening brackets
			stack = append(stack, char)
		case ')':
			// Check if matches
			if len(stack) == 0 || stack[len(stack)-1] != '(' {
				return false
			}
			stack = stack[:len(stack)-1]
		case ']':
			if len(stack) == 0 || stack[len(stack)-1] != '[' {
				return false
			}
			stack = stack[:len(stack)-1]
		case '}':
			if len(stack) == 0 || stack[len(stack)-1] != '{' {
				return false
			}
			stack = stack[:len(stack)-1]
		}
	}

	return len(stack) == 0
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		line := scanner.Text()
		if isBalanced(line) {
			fmt.Println("yes")
		} else {
			fmt.Println("no")
		}
	}
}
