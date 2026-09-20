import sys


def tokenize(s):
    tokens = []
    i = 0
    n = len(s)
    while i < n:
        c = s[i]
        if c.isspace():
            i += 1
        elif c.isdigit():
            j = i
            while j < n and s[j].isdigit():
                j += 1
            tokens.append(int(s[i:j]))
            i = j
        else:
            tokens.append(c)
            i += 1
    return tokens


class Parser:
    def __init__(self, tokens):
        self.tokens = tokens
        self.pos = 0

    def peek(self):
        if self.pos < len(self.tokens):
            return self.tokens[self.pos]
        return None

    def next(self):
        tok = self.tokens[self.pos]
        self.pos += 1
        return tok

    def expr(self):
        val = self.term()
        while self.peek() in ('+', '-'):
            op = self.next()
            rhs = self.term()
            if op == '+':
                val += rhs
            else:
                val -= rhs
        return val

    def term(self):
        val = self.factor()
        while self.peek() in ('*', '/'):
            op = self.next()
            rhs = self.factor()
            if op == '*':
                val *= rhs
            else:
                q = abs(val) // abs(rhs)
                if (val < 0) != (rhs < 0):
                    q = -q
                val = q
        return val

    def factor(self):
        tok = self.next()
        if tok == '(':
            val = self.expr()
            if self.peek() == ')':
                self.next()
            return val
        return tok


def evaluate(line):
    tokens = tokenize(line)
    if not tokens:
        return None
    return Parser(tokens).expr()


def main():
    out = []
    for line in sys.stdin.read().split('\n'):
        if not line.strip():
            continue
        out.append(str(evaluate(line)))
    sys.stdout.write('\n'.join(out) + ('\n' if out else ''))


if __name__ == '__main__':
    main()
