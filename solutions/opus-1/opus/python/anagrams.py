import sys


def main():
    groups = {}
    for line in sys.stdin.read().split():
        groups.setdefault("".join(sorted(line)), []).append(line)
    result = sorted(sorted(words) for words in groups.values())
    sys.stdout.write("".join(" ".join(g) + "\n" for g in result))


main()
