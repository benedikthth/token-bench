use std::collections::HashMap;
use std::io::{self, Read, Write};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut groups: HashMap<Vec<u8>, Vec<&str>> = HashMap::new();
    for line in input.lines() {
        let w = line.trim();
        if w.is_empty() {
            continue;
        }
        let mut key = w.as_bytes().to_vec();
        key.sort_unstable();
        groups.entry(key).or_default().push(w);
    }
    let mut out: Vec<Vec<&str>> = groups.into_values().collect();
    for g in out.iter_mut() {
        g.sort_unstable();
    }
    out.sort_unstable_by(|a, b| a[0].cmp(b[0]));
    let stdout = io::stdout();
    let mut o = io::BufWriter::new(stdout.lock());
    for g in out {
        writeln!(o, "{}", g.join(" ")).unwrap();
    }
}
