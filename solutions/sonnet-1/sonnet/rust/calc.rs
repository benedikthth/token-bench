use std::io::{self, Read, Write};

struct Parser {
    chars: Vec<u8>,
    pos: usize,
}

impl Parser {
    fn new(s: &str) -> Self {
        Parser {
            chars: s.bytes().collect(),
            pos: 0,
        }
    }

    fn skip_ws(&mut self) {
        while self.pos < self.chars.len() && self.chars[self.pos] == b' ' {
            self.pos += 1;
        }
    }

    fn peek(&mut self) -> Option<u8> {
        self.skip_ws();
        if self.pos < self.chars.len() {
            Some(self.chars[self.pos])
        } else {
            None
        }
    }

    fn parse_expr(&mut self) -> i64 {
        let mut value = self.parse_term();
        loop {
            match self.peek() {
                Some(b'+') => {
                    self.pos += 1;
                    value += self.parse_term();
                }
                Some(b'-') => {
                    self.pos += 1;
                    value -= self.parse_term();
                }
                _ => break,
            }
        }
        value
    }

    fn parse_term(&mut self) -> i64 {
        let mut value = self.parse_factor();
        loop {
            match self.peek() {
                Some(b'*') => {
                    self.pos += 1;
                    value *= self.parse_factor();
                }
                Some(b'/') => {
                    self.pos += 1;
                    value /= self.parse_factor();
                }
                _ => break,
            }
        }
        value
    }

    fn parse_factor(&mut self) -> i64 {
        match self.peek() {
            Some(b'(') => {
                self.pos += 1;
                let value = self.parse_expr();
                self.skip_ws();
                if self.peek() == Some(b')') {
                    self.pos += 1;
                }
                value
            }
            _ => self.parse_number(),
        }
    }

    fn parse_number(&mut self) -> i64 {
        self.skip_ws();
        let start = self.pos;
        while self.pos < self.chars.len() && self.chars[self.pos].is_ascii_digit() {
            self.pos += 1;
        }
        let s = std::str::from_utf8(&self.chars[start..self.pos]).unwrap();
        s.parse::<i64>().unwrap()
    }
}

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let stdout = io::stdout();
    let mut out = stdout.lock();
    for line in input.lines() {
        if line.trim().is_empty() {
            continue;
        }
        let mut parser = Parser::new(line);
        let result = parser.parse_expr();
        writeln!(out, "{}", result).unwrap();
    }
}
