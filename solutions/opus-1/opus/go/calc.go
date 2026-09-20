package main

import (
	"bufio"
	"os"
	"strconv"
	"strings"
)

type parser struct {
	s   string
	pos int
}

func (p *parser) skip() {
	for p.pos < len(p.s) && (p.s[p.pos] == ' ' || p.s[p.pos] == '\t') {
		p.pos++
	}
}

func (p *parser) expr() int64 {
	v := p.term()
	for {
		p.skip()
		if p.pos >= len(p.s) {
			return v
		}
		c := p.s[p.pos]
		if c != '+' && c != '-' {
			return v
		}
		p.pos++
		r := p.term()
		if c == '+' {
			v += r
		} else {
			v -= r
		}
	}
}

func (p *parser) term() int64 {
	v := p.factor()
	for {
		p.skip()
		if p.pos >= len(p.s) {
			return v
		}
		c := p.s[p.pos]
		if c != '*' && c != '/' {
			return v
		}
		p.pos++
		r := p.factor()
		if c == '*' {
			v *= r
		} else {
			v /= r
		}
	}
}

func (p *parser) factor() int64 {
	p.skip()
	if p.pos < len(p.s) && p.s[p.pos] == '(' {
		p.pos++
		v := p.expr()
		p.skip()
		if p.pos < len(p.s) && p.s[p.pos] == ')' {
			p.pos++
		}
		return v
	}
	start := p.pos
	for p.pos < len(p.s) && p.s[p.pos] >= '0' && p.s[p.pos] <= '9' {
		p.pos++
	}
	n, _ := strconv.ParseInt(p.s[start:p.pos], 10, 64)
	return n
}

func main() {
	sc := bufio.NewScanner(os.Stdin)
	sc.Buffer(make([]byte, 1<<20), 1<<26)
	w := bufio.NewWriter(os.Stdout)
	defer w.Flush()
	for sc.Scan() {
		line := strings.TrimSpace(sc.Text())
		if line == "" {
			continue
		}
		p := &parser{s: line}
		w.WriteString(strconv.FormatInt(p.expr(), 10))
		w.WriteByte('\n')
	}
}
