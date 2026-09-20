# Read dimensions
r, c = map(int, input().split())

# Read the matrix
matrix = []
for i in range(r):
    row = list(map(int, input().split()))
    matrix.append(row)

# Transpose and print
transposed = zip(*matrix)
for row in transposed:
    print(' '.join(map(str, row)))
