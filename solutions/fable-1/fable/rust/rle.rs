use std::io::{self, Read, Write};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let line = input.lines().next().unwrap_or("");
    let bytes = line.trim_end_matches(['\r', '\n']).as_bytes();

    let mut out = String::new();
    let mut i = 0;
    while i < bytes.len() {
        let c = bytes[i];
        let mut j = i;
        while j < bytes.len() && bytes[j] == c {
            j += 1;
        }
        out.push(c as char);
        out.push_str(&(j - i).to_string());
        i = j;
    }
    out.push('\n');

    io::stdout().write_all(out.as_bytes()).unwrap();
}
