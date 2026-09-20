package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	writer := bufio.NewWriter(os.Stdout)
	defer writer.Flush()

	var n int
	if _, err := fmt.Fscan(reader, &n); err != nil {
		n = 0
	}

	composite := make([]bool, n+1)
	first := true
	for i := 2; i <= n; i++ {
		if composite[i] {
			continue
		}
		if !first {
			writer.WriteByte(' ')
		}
		first = false
		writer.WriteString(strconv.Itoa(i))
		for j := i * i; j <= n; j += i {
			composite[j] = true
		}
	}
	writer.WriteByte('\n')
}
