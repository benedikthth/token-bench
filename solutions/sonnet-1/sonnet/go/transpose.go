package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)
	writer := bufio.NewWriterSize(os.Stdout, 1<<20)
	defer writer.Flush()

	var r, c int
	fmt.Fscan(reader, &r, &c)

	matrix := make([][]int, r)
	for i := 0; i < r; i++ {
		matrix[i] = make([]int, c)
		for j := 0; j < c; j++ {
			fmt.Fscan(reader, &matrix[i][j])
		}
	}

	for j := 0; j < c; j++ {
		for i := 0; i < r; i++ {
			if i > 0 {
				writer.WriteByte(' ')
			}
			writer.WriteString(strconv.Itoa(matrix[i][j]))
		}
		writer.WriteByte('\n')
	}
}
