package main

import (
	"bufio"
	"io"
	"os"
	"strings"
)

func balanced(s string) bool {
	stack := make([]byte, 0, len(s))
	for i := 0; i < len(s); i++ {
		c := s[i]
		switch c {
		case '(', '[', '{':
			stack = append(stack, c)
		case ')', ']', '}':
			var open byte
			switch c {
			case ')':
				open = '('
			case ']':
				open = '['
			default:
				open = '{'
			}
			if len(stack) == 0 || stack[len(stack)-1] != open {
				return false
			}
			stack = stack[:len(stack)-1]
		}
	}
	return len(stack) == 0
}

func main() {
	data, _ := io.ReadAll(os.Stdin)
	text := strings.ReplaceAll(string(data), "\r", "")
	text = strings.TrimSuffix(text, "\n")
	w := bufio.NewWriter(os.Stdout)
	defer w.Flush()
	if len(data) == 0 {
		return
	}
	for _, line := range strings.Split(text, "\n") {
		if balanced(line) {
			w.WriteString("yes\n")
		} else {
			w.WriteString("no\n")
		}
	}
}
