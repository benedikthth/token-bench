import gleam/int
import gleam/list
import gleam/string
import gleam/io
import gleam/result

@external(erlang, "io", "get_line")
pub fn read_line(prompt: String) -> String

// Token type for the lexer
pub type Token {
  Number(Int)
  Plus
  Minus
  Star
  Slash
  LeftParen
  RightParen
  Eof
}

// Parser state
pub type Parser {
  Parser(tokens: List(Token), pos: Int)
}

// Tokenize input string
fn tokenize(input: String) -> List(Token) {
  let chars = string.split(input, "")
  let tokens = tokenize_helper(chars, [])
  list.reverse(tokens)
}

fn tokenize_helper(chars: List(String), acc: List(Token)) -> List(Token) {
  case chars {
    [] -> acc
    [ch, ..rest] ->
      case ch {
        " " -> tokenize_helper(rest, acc)
        "+" -> tokenize_helper(rest, [Plus, ..acc])
        "-" -> tokenize_helper(rest, [Minus, ..acc])
        "*" -> tokenize_helper(rest, [Star, ..acc])
        "/" -> tokenize_helper(rest, [Slash, ..acc])
        "(" -> tokenize_helper(rest, [LeftParen, ..acc])
        ")" -> tokenize_helper(rest, [RightParen, ..acc])
        _ -> {
          let #(num_str, remaining) = collect_number([ch, ..rest], "")
          case int.parse(num_str) {
            Ok(n) -> tokenize_helper(remaining, [Number(n), ..acc])
            Error(_) -> tokenize_helper(remaining, acc)
          }
        }
      }
  }
}

fn collect_number(chars: List(String), acc: String) -> #(String, List(String)) {
  case chars {
    [] -> #(acc, [])
    [ch, ..rest] ->
      case ch {
        "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ->
          collect_number(rest, acc <> ch)
        _ -> #(acc, chars)
      }
  }
}

// Get current token by position
fn get_token(tokens: List(Token), pos: Int) -> Token {
  case tokens {
    [] -> Eof
    [t, ..rest] ->
      case pos {
        0 -> t
        _ -> get_token(rest, pos - 1)
      }
  }
}

// Advance to next token
fn advance(parser: Parser) -> Parser {
  Parser(tokens: parser.tokens, pos: parser.pos + 1)
}

// Parse and evaluate expression with additive precedence
fn parse_expression(parser: Parser) -> #(Int, Parser) {
  parse_additive(parser)
}

// Parse additive level (+ and -)
fn parse_additive(parser: Parser) -> #(Int, Parser) {
  let #(left, parser) = parse_multiplicative(parser)
  parse_additive_rest(left, parser)
}

fn parse_additive_rest(left: Int, parser: Parser) -> #(Int, Parser) {
  let token = get_token(parser.tokens, parser.pos)
  case token {
    Plus -> {
      let parser = advance(parser)
      let #(right, parser) = parse_multiplicative(parser)
      parse_additive_rest(left + right, parser)
    }
    Minus -> {
      let parser = advance(parser)
      let #(right, parser) = parse_multiplicative(parser)
      parse_additive_rest(left - right, parser)
    }
    _ -> #(left, parser)
  }
}

// Parse multiplicative level (* and /)
fn parse_multiplicative(parser: Parser) -> #(Int, Parser) {
  let #(left, parser) = parse_primary(parser)
  parse_multiplicative_rest(left, parser)
}

fn parse_multiplicative_rest(left: Int, parser: Parser) -> #(Int, Parser) {
  let token = get_token(parser.tokens, parser.pos)
  case token {
    Star -> {
      let parser = advance(parser)
      let #(right, parser) = parse_primary(parser)
      parse_multiplicative_rest(left * right, parser)
    }
    Slash -> {
      let parser = advance(parser)
      let #(right, parser) = parse_primary(parser)
      let result = int.divide(left, right) |> result.unwrap(0)
      parse_multiplicative_rest(result, parser)
    }
    _ -> #(left, parser)
  }
}

// Parse primary level (numbers and parenthesized expressions)
fn parse_primary(parser: Parser) -> #(Int, Parser) {
  let token = get_token(parser.tokens, parser.pos)
  case token {
    Number(n) -> #(n, advance(parser))
    LeftParen -> {
      let parser = advance(parser)
      let #(value, parser) = parse_expression(parser)
      let parser = advance(parser)
      #(value, parser)
    }
    _ -> #(0, parser)
  }
}

// Evaluate an expression string
fn evaluate(input: String) -> Int {
  let tokens = tokenize(input)
  let parser = Parser(tokens: tokens, pos: 0)
  let #(result, _) = parse_expression(parser)
  result
}

// Process lines of input
fn process_lines() -> Nil {
  let line = read_line("")
  case line {
    "" -> Nil
    _ -> {
      let line = string.trim(line)
      case line {
        "" -> process_lines()
        _ -> {
          let result = evaluate(line)
          io.println(int.to_string(result))
          process_lines()
        }
      }
    }
  }
}

// Main entry point
pub fn main() {
  process_lines()
}
