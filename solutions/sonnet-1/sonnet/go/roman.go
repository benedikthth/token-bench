package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

var values = []int{1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1}
var symbols = []string{"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"}

func toRoman(n int) string {
	var sb strings.Builder
	for i, v := range values {
		for n >= v {
			sb.WriteString(symbols[i])
			n -= v
		}
	}
	return sb.String()
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	writer := bufio.NewWriter(os.Stdout)
	defer writer.Flush()

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}
		n, err := strconv.Atoi(line)
		if err != nil {
			continue
		}
		fmt.Fprintln(writer, toRoman(n))
	}
}
