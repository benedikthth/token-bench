import sys

def main():
    data = sys.stdin.buffer.read().split()
    if len(data) < 2:
        return
    r, c = int(data[0]), int(data[1])
    vals = data[2:2 + r * c]
    out = []
    for j in range(c):
        out.append(b" ".join(vals[i * c + j] for i in range(r)))
    sys.stdout.buffer.write(b"\n".join(out) + (b"\n" if out else b""))

main()
