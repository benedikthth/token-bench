use std::io::{self, BufRead};

#[derive(Debug, Clone)]
enum Token {
    Number(i64),
    Plus,
    Minus,
    Star,
    Slash,
    LParen,
    RParen,
}

fn tokenize(input: &str) -> Vec<Token> {
    let mut tokens = Vec::new();
    let mut chars = input.chars().peekable();

    while let Some(&ch) = chars.peek() {
        match ch {
            ' ' | '\t' => {
                chars.next();
            }
            '+' => {
                tokens.push(Token::Plus);
                chars.next();
            }
            '-' => {
                tokens.push(Token::Minus);
                chars.next();
            }
            '*' => {
                tokens.push(Token::Star);
                chars.next();
            }
            '/' => {
                tokens.push(Token::Slash);
                chars.next();
            }
            '(' => {
                tokens.push(Token::LParen);
                chars.next();
            }
            ')' => {
                tokens.push(Token::RParen);
                chars.next();
            }
            '0'..='9' => {
                let mut num = 0;
                while let Some(&ch) = chars.peek() {
                    if ch.is_ascii_digit() {
                        num = num * 10 + (ch as i64 - '0' as i64);
                        chars.next();
                    } else {
                        break;
                    }
                }
                tokens.push(Token::Number(num));
            }
            _ => {
                chars.next();
            }
        }
    }

    tokens
}

struct Parser {
    tokens: Vec<Token>,
    pos: usize,
}

impl Parser {
    fn new(tokens: Vec<Token>) -> Self {
        Parser { tokens, pos: 0 }
    }

    fn parse_expression(&mut self) -> i64 {
        self.parse_additive()
    }

    fn parse_additive(&mut self) -> i64 {
        let mut left = self.parse_multiplicative();

        while self.pos < self.tokens.len() {
            match &self.tokens[self.pos] {
                Token::Plus => {
                    self.pos += 1;
                    let right = self.parse_multiplicative();
                    left = left + right;
                }
                Token::Minus => {
                    self.pos += 1;
                    let right = self.parse_multiplicative();
                    left = left - right;
                }
                _ => break,
            }
        }

        left
    }

    fn parse_multiplicative(&mut self) -> i64 {
        let mut left = self.parse_primary();

        while self.pos < self.tokens.len() {
            match &self.tokens[self.pos] {
                Token::Star => {
                    self.pos += 1;
                    let right = self.parse_primary();
                    left = left * right;
                }
                Token::Slash => {
                    self.pos += 1;
                    let right = self.parse_primary();
                    left = left / right;
                }
                _ => break,
            }
        }

        left
    }

    fn parse_primary(&mut self) -> i64 {
        match &self.tokens[self.pos] {
            Token::Number(n) => {
                let result = *n;
                self.pos += 1;
                result
            }
            Token::LParen => {
                self.pos += 1;
                let value = self.parse_additive();
                if self.pos < self.tokens.len() {
                    if let Token::RParen = &self.tokens[self.pos] {
                        self.pos += 1;
                    }
                }
                value
            }
            _ => panic!("Unexpected token at position {}", self.pos),
        }
    }
}

fn main() {
    let stdin = io::stdin();
    for line in stdin.lock().lines() {
        if let Ok(line) = line {
            let line = line.trim();
            if !line.is_empty() {
                let tokens = tokenize(line);
                let mut parser = Parser::new(tokens);
                let result = parser.parse_expression();
                println!("{}", result);
            }
        }
    }
}
