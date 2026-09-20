use std::io::{self, BufRead, Write};

struct Parser<'a> {
    s: &'a [u8],
    pos: usize,
}

impl<'a> Parser<'a> {
    fn skip_ws(&mut self) {
        while self.pos < self.s.len() && self.s[self.pos].is_ascii_whitespace() {
            self.pos += 1;
        }
    }

    fn peek(&mut self) -> Option<u8> {
        self.skip_ws();
        self.s.get(self.pos).copied()
    }

    fn expr(&mut self) -> i128 {
        let mut v = self.term();
        loop {
            match self.peek() {
                Some(b'+') => {
                    self.pos += 1;
                    v += self.term();
                }
                Some(b'-') => {
                    self.pos += 1;
                    v -= self.term();
                }
                _ => return v,
            }
        }
    }

    fn term(&mut self) -> i128 {
        let mut v = self.factor();
        loop {
            match self.peek() {
                Some(b'*') => {
                    self.pos += 1;
                    v *= self.factor();
                }
                Some(b'/') => {
                    self.pos += 1;
                    let d = self.factor();
                    if d != 0 {
                        v /= d;
                    }
                }
                _ => return v,
            }
        }
    }

    fn factor(&mut self) -> i128 {
        match self.peek() {
            Some(b'(') => {
                self.pos += 1;
                let v = self.expr();
                if self.peek() == Some(b')') {
                    self.pos += 1;
                }
                v
            }
            Some(b'-') => {
                self.pos += 1;
                -self.factor()
            }
            Some(b'+') => {
                self.pos += 1;
                self.factor()
            }
            Some(c) if c.is_ascii_digit() => {
                let mut v: i128 = 0;
                while self.pos < self.s.len() && self.s[self.pos].is_ascii_digit() {
                    v = v * 10 + (self.s[self.pos] - b'0') as i128;
                    self.pos += 1;
                }
                v
            }
            _ => 0,
        }
    }
}

fn main() {
    let stdin = io::stdin();
    let stdout = io::stdout();
    let mut out = io::BufWriter::new(stdout.lock());
    for line in stdin.lock().lines() {
        let line = match line {
            Ok(l) => l,
            Err(_) => break,
        };
        if line.trim().is_empty() {
            continue;
        }
        let mut p = Parser { s: line.as_bytes(), pos: 0 };
        let v = p.expr();
        writeln!(out, "{}", v).unwrap();
    }
}
