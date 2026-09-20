import sys


def main():
    data = sys.stdin.read().split()
    n = int(data[0]) if data else 0
    if n < 2:
        print()
        return
    sieve = bytearray([1]) * (n + 1)
    sieve[0] = sieve[1] = 0
    i = 2
    while i * i <= n:
        if sieve[i]:
            sieve[i * i::i] = bytearray(len(range(i * i, n + 1, i)))
        i += 1
    print(" ".join(str(i) for i in range(2, n + 1) if sieve[i]))


if __name__ == "__main__":
    main()
