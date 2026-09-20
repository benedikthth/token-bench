use std::io::{self, Read, Write};

fn to_roman(mut n: u32) -> String {
    let values = [
        (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
        (100, "C"), (90, "XC"), (50, "L"), (40, "XL"),
        (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I"),
    ];
    let mut result = String::new();
    for &(value, symbol) in values.iter() {
        while n >= value {
            result.push_str(symbol);
            n -= value;
        }
    }
    result
}

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut output = String::new();
    for line in input.lines() {
        let line = line.trim();
        if line.is_empty() {
            continue;
        }
        let n: u32 = line.parse().unwrap();
        output.push_str(&to_roman(n));
        output.push('\n');
    }
    io::stdout().write_all(output.as_bytes()).unwrap();
}
