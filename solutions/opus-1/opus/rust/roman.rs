use std::io::{self, Read, Write};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let table: [(u32, &str); 13] = [
        (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
        (100, "C"), (90, "XC"), (50, "L"), (40, "XL"),
        (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I"),
    ];
    let mut out = String::new();
    for tok in input.split_whitespace() {
        let mut n: u32 = match tok.parse() {
            Ok(v) => v,
            Err(_) => continue,
        };
        for &(v, s) in table.iter() {
            while n >= v {
                out.push_str(s);
                n -= v;
            }
        }
        out.push('\n');
    }
    io::stdout().write_all(out.as_bytes()).unwrap();
}
