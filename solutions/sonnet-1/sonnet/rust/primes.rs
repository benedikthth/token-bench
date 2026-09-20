use std::io::{self, Read, Write};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let n: usize = input.trim().parse().unwrap_or(0);

    let mut primes: Vec<usize> = Vec::new();
    if n >= 2 {
        let mut is_composite = vec![false; n + 1];
        for i in 2..=n {
            if !is_composite[i] {
                primes.push(i);
                if let Some(mut j) = i.checked_mul(i) {
                    while j <= n {
                        is_composite[j] = true;
                        j += i;
                    }
                }
            }
        }
    }

    let strings: Vec<String> = primes.iter().map(|p| p.to_string()).collect();
    let out = strings.join(" ");
    let stdout = io::stdout();
    let mut handle = stdout.lock();
    writeln!(handle, "{}", out).unwrap();
}
