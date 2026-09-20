use std::io::{self, Read};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut lines = input.split('\n');
    let a: Vec<u8> = lines.next().unwrap_or("").trim().bytes().collect();
    let b: Vec<u8> = lines.next().unwrap_or("").trim().bytes().collect();
    let m = b.len();
    let mut prev = vec![0u32; m + 1];
    let mut cur = vec![0u32; m + 1];
    for &ca in &a {
        for j in 1..=m {
            cur[j] = if ca == b[j - 1] {
                prev[j - 1] + 1
            } else {
                prev[j].max(cur[j - 1])
            };
        }
        std::mem::swap(&mut prev, &mut cur);
    }
    println!("{}", prev[m]);
}
