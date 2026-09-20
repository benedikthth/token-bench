use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    let reader = stdin.lock();

    for line in reader.lines() {
        if let Ok(line) = line {
            let num: u32 = line.trim().parse().unwrap();
            println!("{}", int_to_roman(num));
        }
    }
}

fn int_to_roman(mut num: u32) -> String {
    let values = [
        (1000, "M"),
        (900, "CM"),
        (500, "D"),
        (400, "CD"),
        (100, "C"),
        (90, "XC"),
        (50, "L"),
        (40, "XL"),
        (10, "X"),
        (9, "IX"),
        (5, "V"),
        (4, "IV"),
        (1, "I"),
    ];

    let mut result = String::new();

    for &(value, symbol) in &values {
        while num >= value {
            result.push_str(symbol);
            num -= value;
        }
    }

    result
}
