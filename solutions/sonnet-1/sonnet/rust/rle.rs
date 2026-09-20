use std::io::{self, Read, Write};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let line = input.lines().next().unwrap_or("");

    let mut output = String::new();
    let mut chars = line.chars().peekable();
    while let Some(c) = chars.next() {
        let mut count = 1;
        while chars.peek() == Some(&c) {
            chars.next();
            count += 1;
        }
        output.push(c);
        output.push_str(&count.to_string());
    }

    let stdout = io::stdout();
    let mut handle = stdout.lock();
    writeln!(handle, "{}", output).unwrap();
}
