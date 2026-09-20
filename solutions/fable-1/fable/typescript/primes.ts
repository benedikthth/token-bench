const input = await Bun.stdin.text();
const n = parseInt(input.trim(), 10) || 0;

const sieve = new Uint8Array(n + 1);
const primes: number[] = [];
for (let i = 2; i <= n; i++) {
  if (sieve[i] === 0) {
    primes.push(i);
    for (let j = i * i; j <= n; j += i) sieve[j] = 1;
  }
}

process.stdout.write(primes.join(" ") + "\n");
