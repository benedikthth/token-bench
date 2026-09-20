const input = require('fs').readFileSync(0, 'utf8').trim();
const n = parseInt(input, 10) || 0;
const sieve = new Uint8Array(n + 1);
const primes = [];
for (let i = 2; i <= n; i++) {
  if (sieve[i]) continue;
  primes.push(i);
  for (let j = i * i; j <= n; j += i) sieve[j] = 1;
}
process.stdout.write(primes.join(' ') + '\n');
