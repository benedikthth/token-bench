const n = parseInt(require('fs').readFileSync(0, 'utf8').trim(), 10) || 0;
const sieve = new Uint8Array(n + 1);
const out = [];
for (let i = 2; i <= n; i++) {
  if (!sieve[i]) {
    out.push(i);
    for (let j = i * i; j <= n; j += i) sieve[j] = 1;
  }
}
process.stdout.write(out.join(' ') + '\n');
