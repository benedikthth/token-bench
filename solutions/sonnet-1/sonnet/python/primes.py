import sys


def main():
    data = sys.stdin.read().split()
    n = int(data[0]) if data else 0

    if n < 2:
        print()
        return

    sieve = [True] * (n + 1)
    sieve[0] = sieve[1] = False
    for i in range(2, int(n ** 0.5) + 1):
        if sieve[i]:
            for j in range(i * i, n + 1, i):
                sieve[j] = False

    primes = [str(i) for i in range(2, n + 1) if sieve[i]]
    print(' '.join(primes))


if __name__ == '__main__':
    main()
