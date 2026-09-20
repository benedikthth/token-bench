import sys
import re
from collections import Counter


def main():
    text = sys.stdin.read()
    words = re.findall(r"[A-Za-z]+", text)
    counts = Counter(w.lower() for w in words)
    for word, count in sorted(counts.items(), key=lambda kv: (-kv[1], kv[0])):
        print(f"{word} {count}")


if __name__ == "__main__":
    main()
