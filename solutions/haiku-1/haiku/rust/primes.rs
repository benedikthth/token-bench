use std::io;

fn main() {
    let mut input = String::new();
    io::stdin().read_line(&mut input).unwrap();
    let n: usize = input.trim().parse().unwrap();

    if n < 2 {
        println!();
        return;
    }

    // Sieve of Eratosthenes
    let mut is_prime = vec![true; n + 1];
    is_prime[0] = false;
    is_prime[1] = false;

    for i in 2..=((n as f64).sqrt() as usize) {
        if is_prime[i] {
            for j in (i * i..=n).step_by(i) {
                is_prime[j] = false;
            }
        }
    }

    let primes: Vec<usize> = (2..=n)
        .filter(|&i| is_prime[i])
        .collect();

    if primes.is_empty() {
        println!();
    } else {
        println!("{}", primes.iter().map(|p| p.to_string()).collect::<Vec<_>>().join(" "));
    }
}
