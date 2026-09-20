import * as readline from "readline";

// Sieve of Eratosthenes to find all primes up to n
function sieveOfEratosthenes(n: number): number[] {
  if (n < 2) {
    return [];
  }

  const isPrime = new Array(n + 1).fill(true);
  isPrime[0] = false;
  isPrime[1] = false;

  for (let i = 2; i * i <= n; i++) {
    if (isPrime[i]) {
      for (let j = i * i; j <= n; j += i) {
        isPrime[j] = false;
      }
    }
  }

  const primes: number[] = [];
  for (let i = 2; i <= n; i++) {
    if (isPrime[i]) {
      primes.push(i);
    }
  }

  return primes;
}

// Read from stdin
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false,
});

rl.on("line", (line: string) => {
  const n = parseInt(line.trim(), 10);
  const primes = sieveOfEratosthenes(n);
  console.log(primes.join(" "));
  rl.close();
});
