use std::io::{self, Read, Write};

struct P<'a> {
    s: &'a [u8],
    i: usize,
}

impl<'a> P<'a> {
    fn ws(&mut self) {
        while self.i < self.s.len() && (self.s[self.i] as char).is_whitespace() {
            self.i += 1;
        }
    }
    fn peek(&mut self) -> Option<u8> {
        self.ws();
        self.s.get(self.i).copied()
    }
    fn expr(&mut self) -> i128 {
        let mut v = self.term();
        while let Some(c) = self.peek() {
            if c == b'+' {
                self.i += 1;
                v += self.term();
            } else if c == b'-' {
                self.i += 1;
                v -= self.term();
            } else {
                break;
            }
        }
        v
    }
    fn term(&mut self) -> i128 {
        let mut v = self.factor();
        while let Some(c) = self.peek() {
            if c == b'*' {
                self.i += 1;
                v *= self.factor();
            } else if c == b'/' {
                self.i += 1;
                v /= self.factor();
            } else {
                break;
            }
        }
        v
    }
    fn factor(&mut self) -> i128 {
        match self.peek() {
            Some(b'(') => {
                self.i += 1;
                let v = self.expr();
                if self.peek() == Some(b')') {
                    self.i += 1;
                }
                v
            }
            _ => {
                let mut v: i128 = 0;
                while self.i < self.s.len() && self.s[self.i].is_ascii_digit() {
                    v = v * 10 + (self.s[self.i] - b'0') as i128;
                    self.i += 1;
                }
                v
            }
        }
    }
}

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut out = String::new();
    for line in input.lines() {
        if line.trim().is_empty() {
            continue;
        }
        let mut p = P { s: line.as_bytes(), i: 0 };
        let v = p.expr();
        out.push_str(&v.to_string());
        out.push('\n');
    }
    io::stdout().write_all(out.as_bytes()).unwrap();
}
