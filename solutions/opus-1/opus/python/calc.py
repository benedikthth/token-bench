import sys


def tokenize(s):
    toks = []
    i, n = 0, len(s)
    while i < n:
        c = s[i]
        if c.isdigit():
            j = i
            while j < n and s[j].isdigit():
                j += 1
            toks.append(int(s[i:j]))
            i = j
        elif c in "+-*/()":
            toks.append(c)
            i += 1
        else:
            i += 1
    return toks


def tdiv(a, b):
    q = abs(a) // abs(b)
    return q if (a < 0) == (b < 0) else -q


def evaluate(toks):
    pos = 0

    def expr():
        nonlocal pos
        v = term()
        while pos < len(toks) and toks[pos] in ("+", "-"):
            op = toks[pos]
            pos += 1
            r = term()
            v = v + r if op == "+" else v - r
        return v

    def term():
        nonlocal pos
        v = factor()
        while pos < len(toks) and toks[pos] in ("*", "/"):
            op = toks[pos]
            pos += 1
            r = factor()
            v = v * r if op == "*" else tdiv(v, r)
        return v

    def factor():
        nonlocal pos
        t = toks[pos]
        pos += 1
        if t == "(":
            v = expr()
            pos += 1
            return v
        return t

    return expr()


def main():
    sys.setrecursionlimit(1000000)
    out = []
    for line in sys.stdin.read().splitlines():
        toks = tokenize(line)
        if not toks:
            continue
        out.append(str(evaluate(toks)))
    sys.stdout.write("\n".join(out) + ("\n" if out else ""))


main()
