import sys


def main():
    data = sys.stdin.read().split()
    idx = 0
    r = int(data[idx]); idx += 1
    c = int(data[idx]); idx += 1
    matrix = []
    for i in range(r):
        row = [int(data[idx + j]) for j in range(c)]
        idx += c
        matrix.append(row)

    out_lines = []
    for j in range(c):
        out_lines.append(" ".join(str(matrix[i][j]) for i in range(r)))

    sys.stdout.write("\n".join(out_lines) + "\n")


if __name__ == "__main__":
    main()
