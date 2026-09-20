package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)
	var sb strings.Builder
	for {
		chunk, err := reader.ReadString('\n')
		sb.WriteString(chunk)
		if err != nil {
			break
		}
	}
	s := strings.TrimRight(sb.String(), "\r\n")

	w := bufio.NewWriter(os.Stdout)
	defer w.Flush()

	n := len(s)
	for i := 0; i < n; {
		j := i + 1
		for j < n && s[j] == s[i] {
			j++
		}
		fmt.Fprintf(w, "%c%d", s[i], j-i)
		i = j
	}
	fmt.Fprintln(w)
}
