import sys


def main():
    s = sys.stdin.readline().rstrip("\r\n")
    out = []
    i = 0
    n = len(s)
    while i < n:
        j = i
        while j < n and s[j] == s[i]:
            j += 1
        out.append(s[i] + str(j - i))
        i = j
    sys.stdout.write("".join(out) + "\n")


if __name__ == "__main__":
    main()
