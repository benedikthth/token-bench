use std::collections::HashMap;
use std::io::{self, Read, Write};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();

    let mut groups: HashMap<Vec<u8>, Vec<String>> = HashMap::new();
    for line in input.lines() {
        let word = line.trim();
        if word.is_empty() {
            continue;
        }
        let mut key = word.as_bytes().to_vec();
        key.sort_unstable();
        groups.entry(key).or_default().push(word.to_string());
    }

    let mut result: Vec<Vec<String>> = groups.into_values().collect();
    for g in result.iter_mut() {
        g.sort();
    }
    result.sort();

    let stdout = io::stdout();
    let mut out = io::BufWriter::new(stdout.lock());
    for g in result {
        writeln!(out, "{}", g.join(" ")).unwrap();
    }
}
