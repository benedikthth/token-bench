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

	readInt := func() (int64, bool) {
		n := int64(0)
		c, err := reader.ReadByte()
		for err == nil && (c == ' ' || c == '\n' || c == '\r' || c == '\t') {
			c, err = reader.ReadByte()
		}
		if err != nil {
			return 0, false
		}
		neg := false
		if c == '-' {
			neg = true
			c, err = reader.ReadByte()
		} else if c == '+' {
			c, err = reader.ReadByte()
		}
		for err == nil && c >= '0' && c <= '9' {
			n = n*10 + int64(c-'0')
			c, err = reader.ReadByte()
		}
		if neg {
			n = -n
		}
		return n, true
	}

	r64, ok := readInt()
	if !ok {
		return
	}
	c64, _ := readInt()
	r, c := int(r64), int(c64)
	if r <= 0 || c <= 0 {
		return
	}

	data := make([]int64, r*c)
	for i := 0; i < r*c; i++ {
		data[i], _ = readInt()
	}

	buf := make([]byte, 0, 24)
	for j := 0; j < c; j++ {
		for i := 0; i < r; i++ {
			if i > 0 {
				writer.WriteByte(' ')
			}
			buf = strconv.AppendInt(buf[:0], data[i*c+j], 10)
			writer.Write(buf)
		}
		writer.WriteByte('\n')
	}
}
