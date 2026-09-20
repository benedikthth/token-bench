import sys

# Read all words
words = []
for line in sys.stdin:
    word = line.strip()
    if word:
        words.append(word)

# Group anagrams by their canonical form (sorted letters)
groups_dict = {}
for word in words:
    canonical = ''.join(sorted(word))
    if canonical not in groups_dict:
        groups_dict[canonical] = []
    groups_dict[canonical].append(word)

# Sort words within each group and collect all groups
groups = []
for word_list in groups_dict.values():
    word_list.sort()  # Sort alphabetically
    groups.append(word_list)

# Sort groups by their first word
groups.sort(key=lambda g: g[0])

# Output
for group in groups:
    print(' '.join(group))
