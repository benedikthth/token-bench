use std::collections::HashMap;
use std::io::{self, Read, Write};

fn main() {
    let mut input = Vec::new();
    io::stdin().read_to_end(&mut input).unwrap();
    let mut counts: HashMap<Vec<u8>, usize> = HashMap::new();
    let mut cur: Vec<u8> = Vec::new();
    for &b in input.iter().chain(std::iter::once(&b' ')) {
        if b.is_ascii_alphabetic() {
            cur.push(b.to_ascii_lowercase());
        } else if !cur.is_empty() {
            *counts.entry(std::mem::take(&mut cur)).or_insert(0) += 1;
        }
    }
    let mut v: Vec<(Vec<u8>, usize)> = counts.into_iter().collect();
    v.sort_by(|a, b| b.1.cmp(&a.1).then_with(|| a.0.cmp(&b.0)));
    let stdout = io::stdout();
    let mut out = io::BufWriter::new(stdout.lock());
    for (w, c) in v {
        out.write_all(&w).unwrap();
        writeln!(out, " {}", c).unwrap();
    }
}
