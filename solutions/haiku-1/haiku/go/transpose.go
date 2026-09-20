package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	// Read the first line with R and C
	scanner.Scan()
	parts := strings.Fields(scanner.Text())
	R := atoi(parts[0])
	C := atoi(parts[1])

	// Read the matrix
	matrix := make([][]int, R)
	for i := 0; i < R; i++ {
		scanner.Scan()
		nums := strings.Fields(scanner.Text())
		matrix[i] = make([]int, C)
		for j := 0; j < C; j++ {
			matrix[i][j] = atoi(nums[j])
		}
	}

	// Output the transposed matrix
	for j := 0; j < C; j++ {
		for i := 0; i < R; i++ {
			if i > 0 {
				fmt.Print(" ")
			}
			fmt.Print(matrix[i][j])
		}
		fmt.Println()
	}
}

func atoi(s string) int {
	n, _ := strconv.Atoi(s)
	return n
}
