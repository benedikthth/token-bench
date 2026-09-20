import re
import sys
from collections import Counter

data = sys.stdin.buffer.read().decode("latin-1")
counts = Counter(w.lower() for w in re.findall(r"[A-Za-z]+", data))
out = [f"{w} {c}" for w, c in sorted(counts.items(), key=lambda x: (-x[1], x[0]))]
sys.stdout.write("\n".join(out) + ("\n" if out else ""))
