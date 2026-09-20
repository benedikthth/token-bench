import sys
from collections import defaultdict


def main():
    groups = defaultdict(list)
    for line in sys.stdin:
        word = line.strip()
        if not word:
            continue
        groups["".join(sorted(word))].append(word)
    out = []
    for words in groups.values():
        words.sort()
        out.append(words)
    out.sort(key=lambda g: g[0])
    sys.stdout.write("".join(" ".join(g) + "\n" for g in out))


if __name__ == "__main__":
    main()
