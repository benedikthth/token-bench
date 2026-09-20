import sys


def lcs_length(a, b):
    # Bit-parallel LCS (Hyyro / Allison-Dix). Rows of the DP table are
    # encoded as big integers; each step costs O(len(a)/wordsize).
    n = len(a)
    if n == 0 or len(b) == 0:
        return 0
    masks = {}
    for i, ch in enumerate(a):
        masks[ch] = masks.get(ch, 0) | (1 << i)
    full = (1 << n) - 1
    v = full
    for ch in b:
        m = masks.get(ch, 0)
        u = v & m
        v = ((v + u) | (v - u)) & full
    # Zero bits of v correspond to matched positions.
    return n - bin(v).count("1")


def main():
    data = sys.stdin.read().split("\n")
    a = data[0].rstrip("\r") if len(data) > 0 else ""
    b = data[1].rstrip("\r") if len(data) > 1 else ""
    print(lcs_length(a, b))


main()
