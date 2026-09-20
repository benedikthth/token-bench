package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	var n int
	fmt.Fscan(bufio.NewReader(os.Stdin), &n)
	w := bufio.NewWriter(os.Stdout)
	defer w.Flush()
	composite := make([]bool, n+1)
	first := true
	for i := 2; i <= n; i++ {
		if composite[i] {
			continue
		}
		for j := i * i; j <= n; j += i {
			composite[j] = true
		}
		if !first {
			w.WriteByte(' ')
		}
		w.WriteString(strconv.Itoa(i))
		first = false
	}
	w.WriteByte('\n')
}
