package main

import (
	"bufio"
	"os"
	"strconv"
	"strings"
)

func main() {
	vals := []int{1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1}
	syms := []string{"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"}
	sc := bufio.NewScanner(os.Stdin)
	w := bufio.NewWriter(os.Stdout)
	defer w.Flush()
	for sc.Scan() {
		line := strings.TrimSpace(sc.Text())
		if line == "" {
			continue
		}
		n, err := strconv.Atoi(line)
		if err != nil {
			continue
		}
		var b strings.Builder
		for i, v := range vals {
			for n >= v {
				b.WriteString(syms[i])
				n -= v
			}
		}
		w.WriteString(b.String())
		w.WriteByte('\n')
	}
}
