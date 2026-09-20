import sys

s = sys.stdin.readline().strip()
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
