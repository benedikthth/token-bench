use std::io::{self, BufRead};

fn is_balanced(line: &str) -> bool {
    let mut stack = Vec::new();

    for ch in line.chars() {
        match ch {
            '(' | '[' | '{' => stack.push(ch),
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
            _ => {} // Should not happen per problem spec
        }
    }

    stack.is_empty()
}

fn main() {
    let stdin = io::stdin();
    let reader = stdin.lock();

    for line in reader.lines() {
        match line {
            Ok(line) => {
                if is_balanced(&line) {
                    println!("yes");
                } else {
                    println!("no");
                }
            }
            Err(_) => break,
        }
    }
}
