package main

import (
	"bufio"
	"io"
	"os"
	"strconv"
	"strings"
)

func main() {
	data, _ := io.ReadAll(bufio.NewReader(os.Stdin))
	s := string(data)
	if i := strings.IndexByte(s, '\n'); i >= 0 {
		s = s[:i]
	}
	s = strings.TrimRight(s, "\r")
	w := bufio.NewWriter(os.Stdout)
	defer w.Flush()
	for i := 0; i < len(s); {
		j := i
		for j < len(s) && s[j] == s[i] {
			j++
		}
		w.WriteByte(s[i])
		w.WriteString(strconv.Itoa(j - i))
		i = j
	}
	w.WriteByte('\n')
}
