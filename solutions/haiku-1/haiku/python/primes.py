def sieve_of_eratosthenes(n):
    if n < 2:
        return []

    # Create a boolean array and initialize all entries as true
    is_prime = [True] * (n + 1)
    is_prime[0] = is_prime[1] = False

    p = 2
    while p * p <= n:
        if is_prime[p]:
            # Mark all multiples of p as not prime
            for i in range(p * p, n + 1, p):
                is_prime[i] = False
        p += 1

    # Collect all prime numbers
    primes = [i for i in range(n + 1) if is_prime[i]]
    return primes


# Read input
n = int(input())

# Get all primes up to n
primes = sieve_of_eratosthenes(n)

# Output
if primes:
    print(' '.join(map(str, primes)))
else:
    print()
