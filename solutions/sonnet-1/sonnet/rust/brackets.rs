use std::io::{self, Read, Write};

fn is_balanced(line: &str) -> bool {
    let mut stack: Vec<char> = Vec::new();
    for c in line.chars() {
        match c {
            '(' | '[' | '{' => stack.push(c),
            ')' => {
                if stack.pop() != Some('(') {
                    return false;
                }
            }
            ']' => {
                if stack.pop() != Some('[') {
                    return false;
                }
            }
            '}' => {
                if stack.pop() != Some('{') {
                    return false;
                }
            }
            _ => {}
        }
    }
    stack.is_empty()
}

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();

    let mut lines: Vec<&str> = input.lines().collect();
    // If the input doesn't end with a newline but has trailing content, lines() already handles it.
    // If input is empty, there are no lines to process (but spec says "one or more lines").
    if input.is_empty() {
        lines = vec![];
    }

    let stdout = io::stdout();
    let mut out = stdout.lock();
    let mut result = String::new();
    for line in lines {
        if is_balanced(line) {
            result.push_str("yes\n");
        } else {
            result.push_str("no\n");
        }
    }
    out.write_all(result.as_bytes()).unwrap();
}
