package main

import (
	"bufio"
	"os"
	"strconv"
)

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)
	writer := bufio.NewWriterSize(os.Stdout, 1<<20)
	defer writer.Flush()

	readInt := func() (int, bool) {
		n, neg, started := 0, false, false
		for {
			b, err := reader.ReadByte()
			if err != nil {
				if !started {
					return 0, false
				}
				break
			}
			if b == '-' && !started {
				neg = true
				started = true
				continue
			}
			if b >= '0' && b <= '9' {
				n = n*10 + int(b-'0')
				started = true
				continue
			}
			if started {
				break
			}
		}
		if neg {
			n = -n
		}
		return n, true
	}

	r, _ := readInt()
	c, _ := readInt()
	m := make([]int, r*c)
	for i := range m {
		m[i], _ = readInt()
	}
	for j := 0; j < c; j++ {
		for i := 0; i < r; i++ {
			if i > 0 {
				writer.WriteByte(' ')
			}
			writer.WriteString(strconv.Itoa(m[i*c+j]))
		}
		writer.WriteByte('\n')
	}
}
