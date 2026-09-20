package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"unicode"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			continue
		}
		result := evaluate(line)
		fmt.Println(result)
	}
}

func evaluate(expr string) int64 {
	tokens := tokenize(expr)
	parser := &Parser{tokens: tokens, pos: 0}
	return parser.parseExpression()
}

type Parser struct {
	tokens []string
	pos    int
}

// parseExpression handles + and - (lowest precedence)
func (p *Parser) parseExpression() int64 {
	left := p.parseTerm()

	for p.pos < len(p.tokens) {
		token := p.tokens[p.pos]
		if token == "+" || token == "-" {
			p.pos++
			right := p.parseTerm()
			if token == "+" {
				left = left + right
			} else {
				left = left - right
			}
		} else {
			break
		}
	}

	return left
}

// parseTerm handles * and / (higher precedence)
func (p *Parser) parseTerm() int64 {
	left := p.parseFactor()

	for p.pos < len(p.tokens) {
		token := p.tokens[p.pos]
		if token == "*" || token == "/" {
			p.pos++
			right := p.parseFactor()
			if token == "*" {
				left = left * right
			} else {
				left = truncDiv(left, right)
			}
		} else {
			break
		}
	}

	return left
}

// parseFactor handles numbers and parenthesized expressions
func (p *Parser) parseFactor() int64 {
	token := p.tokens[p.pos]
	p.pos++

	if token == "(" {
		result := p.parseExpression()
		if p.pos < len(p.tokens) && p.tokens[p.pos] == ")" {
			p.pos++
		}
		return result
	} else {
		// It's a number
		num, _ := strconv.ParseInt(token, 10, 64)
		return num
	}
}

// truncDiv performs integer division that truncates toward zero
func truncDiv(a, b int64) int64 {
	q := a / b
	r := a % b
	// If there's a remainder and signs differ, we need to round toward zero
	if r != 0 && (a < 0) != (b < 0) {
		q++
	}
	return q
}

// tokenize splits an expression into tokens
func tokenize(expr string) []string {
	var tokens []string
	var current string

	for _, ch := range expr {
		if unicode.IsDigit(ch) {
			current += string(ch)
		} else if ch == '+' || ch == '-' || ch == '*' || ch == '/' || ch == '(' || ch == ')' {
			if current != "" {
				tokens = append(tokens, current)
				current = ""
			}
			tokens = append(tokens, string(ch))
		} else if unicode.IsSpace(ch) {
			if current != "" {
				tokens = append(tokens, current)
				current = ""
			}
		}
	}

	if current != "" {
		tokens = append(tokens, current)
	}

	return tokens
}
