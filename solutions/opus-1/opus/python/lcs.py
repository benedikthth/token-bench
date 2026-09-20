import sys


def main():
    lines = sys.stdin.read().split("\n")
    a = lines[0].strip() if len(lines) > 0 else ""
    b = lines[1].strip() if len(lines) > 1 else ""
    m = len(a)
    if m == 0 or not b:
        print(0)
        return
    masks = {}
    for i, ch in enumerate(a):
        masks[ch] = masks.get(ch, 0) | (1 << i)
    full = (1 << m) - 1
    v = full
    for ch in b:
        u = v & masks.get(ch, 0)
        v = ((v + u) | (v - u)) & full
    print(m - bin(v).count("1"))


main()
