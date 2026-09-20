package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	line, _ := reader.ReadString('\n')
	for len(line) > 0 && (line[len(line)-1] == '\n' || line[len(line)-1] == '\r') {
		line = line[:len(line)-1]
	}

	var out []byte
	i := 0
	for i < len(line) {
		j := i
		for j < len(line) && line[j] == line[i] {
			j++
		}
		out = append(out, line[i])
		out = append(out, []byte(fmt.Sprintf("%d", j-i))...)
		i = j
	}
	fmt.Println(string(out))
}
