use std::io::{self, BufRead, Write};

fn balanced(line: &str) -> bool {
    let mut stack: Vec<u8> = Vec::new();
    for b in line.bytes() {
        match b {
            b'(' | b'[' | b'{' => stack.push(b),
            b')' | b']' | b'}' => {
                let expected = match b {
                    b')' => b'(',
                    b']' => b'[',
                    _ => b'{',
                };
                if stack.pop() != Some(expected) {
                    return false;
                }
            }
            b'\r' | b' ' | b'\t' => {}
            _ => return false,
        }
    }
    stack.is_empty()
}

fn main() {
    let stdin = io::stdin();
    let stdout = io::stdout();
    let mut out = io::BufWriter::new(stdout.lock());
    for line in stdin.lock().lines() {
        let line = match line {
            Ok(l) => l,
            Err(_) => break,
        };
        let ans = if balanced(&line) { "yes" } else { "no" };
        writeln!(out, "{}", ans).unwrap();
    }
    out.flush().unwrap();
}
