import sys
import re
from collections import Counter


def main():
    text = sys.stdin.read()
    words = re.findall(r"[A-Za-z]+", text)
    counts = Counter(w.lower() for w in words)
    items = sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))
    sys.stdout.write("".join(f"{w} {c}\n" for w, c in items))


if __name__ == "__main__":
    main()
