const data = require('fs').readFileSync(0, 'utf8');
const n = parseInt(data.trim(), 10);

if (!n || n < 2) {
  console.log('');
} else {
  const sieve = new Uint8Array(n + 1);
  const primes = [];
  for (let i = 2; i <= n; i++) {
    if (!sieve[i]) {
      primes.push(i);
      for (let j = i * i; j <= n; j += i) {
        sieve[j] = 1;
      }
    }
  }
  console.log(primes.join(' '));
}
