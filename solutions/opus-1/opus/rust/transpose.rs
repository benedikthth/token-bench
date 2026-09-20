use std::io::{self, Read, Write};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut it = input.split_ascii_whitespace();
    let r: usize = match it.next() {
        Some(t) => t.parse().unwrap(),
        None => return,
    };
    let c: usize = it.next().unwrap().parse().unwrap();
    let mut m: Vec<&str> = Vec::with_capacity(r * c);
    for _ in 0..r * c {
        m.push(it.next().unwrap());
    }
    let mut out = String::new();
    for j in 0..c {
        for i in 0..r {
            if i > 0 {
                out.push(' ');
            }
            out.push_str(m[i * c + j]);
        }
        out.push('\n');
    }
    io::stdout().write_all(out.as_bytes()).unwrap();
}
