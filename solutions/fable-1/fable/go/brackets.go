package main

import (
	"bufio"
	"os"
)

func balanced(s string) bool {
	stack := make([]byte, 0, len(s))
	for i := 0; i < len(s); i++ {
		c := s[i]
		switch c {
		case '(', '[', '{':
			stack = append(stack, c)
		case ')', ']', '}':
			if len(stack) == 0 {
				return false
			}
			top := stack[len(stack)-1]
			if (c == ')' && top != '(') || (c == ']' && top != '[') || (c == '}' && top != '{') {
				return false
			}
			stack = stack[:len(stack)-1]
		case '\r', ' ', '\t':
			// ignore stray whitespace
		default:
			return false
		}
	}
	return len(stack) == 0
}

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)
	writer := bufio.NewWriter(os.Stdout)
	defer writer.Flush()

	scanner := bufio.NewScanner(reader)
	scanner.Buffer(make([]byte, 1<<20), 1<<30)
	for scanner.Scan() {
		if balanced(scanner.Text()) {
			writer.WriteString("yes\n")
		} else {
			writer.WriteString("no\n")
		}
	}
}
