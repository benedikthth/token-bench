use std::io::{self, Read};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut lines = input.lines();
    let a = lines.next().unwrap_or("").trim_end_matches('\r').as_bytes();
    let b = lines.next().unwrap_or("").trim_end_matches('\r').as_bytes();

    let n = a.len();
    let m = b.len();

    let mut prev = vec![0u32; m + 1];
    let mut curr = vec![0u32; m + 1];

    for i in 1..=n {
        for j in 1..=m {
            if a[i - 1] == b[j - 1] {
                curr[j] = prev[j - 1] + 1;
            } else {
                curr[j] = if prev[j] >= curr[j - 1] { prev[j] } else { curr[j - 1] };
            }
        }
        std::mem::swap(&mut prev, &mut curr);
    }

    println!("{}", prev[m]);
}
