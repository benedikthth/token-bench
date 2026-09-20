from itertools import groupby

line = input()
result = ''.join(char + str(len(list(group))) for char, group in groupby(line))
print(result)
