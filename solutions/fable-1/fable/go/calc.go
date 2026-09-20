package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

type parser struct {
	s   string
	pos int
}

func (p *parser) skip() {
	for p.pos < len(p.s) && (p.s[p.pos] == ' ' || p.s[p.pos] == '\t' || p.s[p.pos] == '\r') {
		p.pos++
	}
}

func (p *parser) peek() byte {
	p.skip()
	if p.pos < len(p.s) {
		return p.s[p.pos]
	}
	return 0
}

func (p *parser) expr() int64 {
	v := p.term()
	for {
		c := p.peek()
		if c == '+' {
			p.pos++
			v += p.term()
		} else if c == '-' {
			p.pos++
			v -= p.term()
		} else {
			return v
		}
	}
}

func (p *parser) term() int64 {
	v := p.factor()
	for {
		c := p.peek()
		if c == '*' {
			p.pos++
			v *= p.factor()
		} else if c == '/' {
			p.pos++
			d := p.factor()
			if d != 0 {
				v /= d // Go integer division truncates toward zero
			}
		} else {
			return v
		}
	}
}

func (p *parser) factor() int64 {
	c := p.peek()
	if c == '(' {
		p.pos++
		v := p.expr()
		if p.peek() == ')' {
			p.pos++
		}
		return v
	}
	var v int64
	for p.pos < len(p.s) && p.s[p.pos] >= '0' && p.s[p.pos] <= '9' {
		v = v*10 + int64(p.s[p.pos]-'0')
		p.pos++
	}
	return v
}

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)
	writer := bufio.NewWriter(os.Stdout)
	defer writer.Flush()
	for {
		line, err := reader.ReadString('\n')
		if len(line) == 0 && err != nil {
			break
		}
		line = strings.TrimRight(line, "\r\n")
		if strings.TrimSpace(line) == "" {
			if err != nil {
				break
			}
			continue
		}
		p := &parser{s: line}
		fmt.Fprintln(writer, p.expr())
		if err != nil {
			break
		}
	}
}
