use std::io::{self, Read, Write};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut it = input.split_ascii_whitespace();
    let r: usize = match it.next() {
        Some(x) => x.parse().unwrap(),
        None => return,
    };
    let c: usize = it.next().unwrap().parse().unwrap();
    let mut m: Vec<&str> = Vec::with_capacity(r * c);
    for _ in 0..r * c {
        m.push(it.next().unwrap_or("0"));
    }
    let stdout = io::stdout();
    let mut out = io::BufWriter::new(stdout.lock());
    for j in 0..c {
        for i in 0..r {
            if i > 0 {
                out.write_all(b" ").unwrap();
            }
            out.write_all(m[i * c + j].as_bytes()).unwrap();
        }
        out.write_all(b"\n").unwrap();
    }
}
