use std::io::{self, Read, Write};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let n: usize = input.trim().parse().unwrap_or(0);

    let mut sieve = vec![true; n + 1];
    if n >= 0 {
        sieve[0] = false;
    }
    if n >= 1 {
        sieve[1] = false;
    }
    let mut i = 2;
    while i * i <= n {
        if sieve[i] {
            let mut j = i * i;
            while j <= n {
                sieve[j] = false;
                j += i;
            }
        }
        i += 1;
    }

    let primes: Vec<String> = (2..=n).filter(|&k| sieve[k]).map(|k| k.to_string()).collect();
    let stdout = io::stdout();
    let mut out = stdout.lock();
    writeln!(out, "{}", primes.join(" ")).unwrap();
}
