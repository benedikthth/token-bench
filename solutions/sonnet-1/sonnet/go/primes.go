package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	var n int
	_, err := fmt.Fscan(reader, &n)
	if err != nil {
		return
	}

	writer := bufio.NewWriter(os.Stdout)
	defer writer.Flush()

	if n < 2 {
		fmt.Fprintln(writer)
		return
	}

	sieve := make([]bool, n+1)
	var parts []string
	for i := 2; i <= n; i++ {
		if !sieve[i] {
			parts = append(parts, strconv.Itoa(i))
			for j := i * 2; j <= n; j += i {
				sieve[j] = true
			}
		}
	}

	fmt.Fprintln(writer, strings.Join(parts, " "))
}
