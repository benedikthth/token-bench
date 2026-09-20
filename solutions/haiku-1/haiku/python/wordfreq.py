import sys
import re
from collections import Counter

# Read all input
text = sys.stdin.read()

# Extract words (maximal runs of ASCII letters)
words = re.findall(r'[a-zA-Z]+', text)

# Convert to lowercase and count
word_counts = Counter(word.lower() for word in words)

# Sort by count (descending), then by word (ascending)
sorted_words = sorted(word_counts.items(), key=lambda x: (-x[1], x[0]))

# Output
for word, count in sorted_words:
    print(f"{word} {count}")
