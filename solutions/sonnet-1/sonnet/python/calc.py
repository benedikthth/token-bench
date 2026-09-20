import sys


def tokenize(line):
    tokens = []
    i = 0
    n = len(line)
    while i < n:
        c = line[i]
        if c.isspace():
            i += 1
            continue
        if c.isdigit():
            j = i
            while j < n and line[j].isdigit():
                j += 1
            tokens.append(('num', int(line[i:j])))
            i = j
            continue
        if c in '+-*/()':
            tokens.append((c, c))
            i += 1
            continue
        raise ValueError(f'Unexpected character: {c!r}')
    return tokens


def parse_expr(tokens, pos):
    value, pos = parse_term(tokens, pos)
    while pos < len(tokens) and tokens[pos][0] in ('+', '-'):
        op = tokens[pos][0]
        pos += 1
        rhs, pos = parse_term(tokens, pos)
        if op == '+':
            value += rhs
        else:
            value -= rhs
    return value, pos


def parse_term(tokens, pos):
    value, pos = parse_factor(tokens, pos)
    while pos < len(tokens) and tokens[pos][0] in ('*', '/'):
        op = tokens[pos][0]
        pos += 1
        rhs, pos = parse_factor(tokens, pos)
        if op == '*':
            value *= rhs
        else:
            # integer division truncating toward zero
            q = abs(value) // abs(rhs)
            if (value < 0) != (rhs < 0):
                q = -q
            value = q
    return value, pos


def parse_factor(tokens, pos):
    tok = tokens[pos]
    if tok[0] == '(':
        value, pos = parse_expr(tokens, pos + 1)
        # tokens[pos] should be ')'
        pos += 1
        return value, pos
    if tok[0] == 'num':
        return tok[1], pos + 1
    raise ValueError(f'Unexpected token: {tok}')


def evaluate(line):
    tokens = tokenize(line)
    value, pos = parse_expr(tokens, 0)
    return value


def main():
    for line in sys.stdin:
        line = line.rstrip('\n')
        if line.strip() == '':
            continue
        print(evaluate(line))


if __name__ == '__main__':
    main()
