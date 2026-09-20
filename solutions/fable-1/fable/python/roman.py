import sys

PAIRS = [
    (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
    (100, "C"), (90, "XC"), (50, "L"), (40, "XL"),
    (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I"),
]


def to_roman(n):
    out = []
    for value, sym in PAIRS:
        while n >= value:
            out.append(sym)
            n -= value
    return "".join(out)


def main():
    lines = []
    for line in sys.stdin:
        s = line.strip()
        if s:
            lines.append(to_roman(int(s)))
    sys.stdout.write("\n".join(lines) + ("\n" if lines else ""))


if __name__ == "__main__":
    main()
