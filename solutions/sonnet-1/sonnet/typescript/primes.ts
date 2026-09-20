function main() {
  const input = require("fs").readFileSync(0, "utf8").trim();
  const n = parseInt(input, 10) || 0;

  if (n < 2) {
    console.log("");
    return;
  }

  const sieve = new Uint8Array(n + 1);
  const primes: number[] = [];

  for (let i = 2; i <= n; i++) {
    if (sieve[i] === 0) {
      primes.push(i);
      for (let j = i * i; j <= n; j += i) {
        sieve[j] = 1;
      }
    }
  }

  console.log(primes.join(" "));
}

main();
