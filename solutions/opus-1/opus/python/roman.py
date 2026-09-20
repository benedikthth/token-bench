import sys

VALS = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"),
        (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]

out = []
for tok in sys.stdin.read().split():
    n = int(tok)
    s = []
    for v, r in VALS:
        while n >= v:
            s.append(r)
            n -= v
    out.append("".join(s))
sys.stdout.write("\n".join(out) + ("\n" if out else ""))
