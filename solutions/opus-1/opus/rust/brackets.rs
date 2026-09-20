use std::io::{self, Read, Write};

fn balanced(line: &str) -> bool {
    let mut stack = Vec::new();
    for c in line.chars() {
        match c {
            '(' | '[' | '{' => stack.push(c),
            ')' => if stack.pop() != Some('(') { return false; },
            ']' => if stack.pop() != Some('[') { return false; },
            '}' => if stack.pop() != Some('{') { return false; },
            _ => {}
        }
    }
    stack.is_empty()
}

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut out = String::new();
    for line in input.lines() {
        let line = line.trim_end_matches('\r');
        out.push_str(if balanced(line) { "yes\n" } else { "no\n" });
    }
    io::stdout().write_all(out.as_bytes()).unwrap();
}
