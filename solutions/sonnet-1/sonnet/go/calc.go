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

func (p *parser) skipSpaces() {
	for p.pos < len(p.s) && p.s[p.pos] == ' ' {
		p.pos++
	}
}

func (p *parser) peek() byte {
	p.skipSpaces()
	if p.pos >= len(p.s) {
		return 0
	}
	return p.s[p.pos]
}

func (p *parser) parseExpr() int64 {
	v := p.parseTerm()
	for {
		c := p.peek()
		if c == '+' {
			p.pos++
			v += p.parseTerm()
		} else if c == '-' {
			p.pos++
			v -= p.parseTerm()
		} else {
			break
		}
	}
	return v
}

func (p *parser) parseTerm() int64 {
	v := p.parseFactor()
	for {
		c := p.peek()
		if c == '*' {
			p.pos++
			v *= p.parseFactor()
		} else if c == '/' {
			p.pos++
			v /= p.parseFactor()
		} else {
			break
		}
	}
	return v
}

func (p *parser) parseFactor() int64 {
	c := p.peek()
	if c == '(' {
		p.pos++
		v := p.parseExpr()
		p.skipSpaces()
		if p.pos < len(p.s) && p.s[p.pos] == ')' {
			p.pos++
		}
		return v
	}
	return p.parseNumber()
}

func (p *parser) parseNumber() int64 {
	p.skipSpaces()
	start := p.pos
	for p.pos < len(p.s) && p.s[p.pos] >= '0' && p.s[p.pos] <= '9' {
		p.pos++
	}
	var v int64 = 0
	for _, ch := range p.s[start:p.pos] {
		v = v*10 + int64(ch-'0')
	}
	return v
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Buffer(make([]byte, 1024*1024), 1024*1024)
	writer := bufio.NewWriter(os.Stdout)
	defer writer.Flush()

	for scanner.Scan() {
		line := scanner.Text()
		if strings.TrimSpace(line) == "" {
			continue
		}
		p := &parser{s: line}
		result := p.parseExpr()
		fmt.Fprintln(writer, result)
	}
}
