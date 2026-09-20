import sys
from collections import defaultdict


def main():
    words = [line.strip() for line in sys.stdin if line.strip()]

    groups = defaultdict(list)
    for word in words:
        key = "".join(sorted(word))
        groups[key].append(word)

    result = []
    for key, group in groups.items():
        group.sort()
        result.append(group)

    result.sort(key=lambda g: g[0])

    out_lines = [" ".join(group) for group in result]
    sys.stdout.write("\n".join(out_lines) + ("\n" if out_lines else ""))


if __name__ == "__main__":
    main()
