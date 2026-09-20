import gleam/int
import gleam/io
import gleam/list
import gleam/string

// ---------- stdin via Erlang FFI ----------

type Opt {
  Binary
}

@external(erlang, "io", "setopts")
fn setopts(opts: List(Opt)) -> a

@external(erlang, "io", "get_line")
fn raw_get_line(prompt: String) -> a

@external(erlang, "erlang", "is_binary")
fn is_binary(x: a) -> Bool

@external(erlang, "erlang", "is_list")
fn is_list(x: a) -> Bool

@external(erlang, "unicode", "characters_to_binary")
fn chars_to_binary(x: a) -> b

@external(erlang, "erlang", "hd")
fn hd(l: List(a)) -> b

fn coerce(x: a) -> b {
  hd([x])
}

fn read_line() -> Result(String, Nil) {
  let raw = raw_get_line("")
  case is_binary(raw) {
    True -> Ok(coerce(raw))
    False ->
      case is_list(raw) {
        True -> Ok(coerce(chars_to_binary(raw)))
        False -> Error(Nil)
      }
  }
}

// ---------- tokenizer ----------

type Token {
  Num(Int)
  Plus
  Minus
  Star
  Slash
  LParen
  RParen
}

fn tokenize(chars: List(String), acc: List(Token)) -> List(Token) {
  case chars {
    [] -> list.reverse(acc)
    [c, ..rest] ->
      case c {
        " " | "\t" | "\r" | "\n" -> tokenize(rest, acc)
        "+" -> tokenize(rest, [Plus, ..acc])
        "-" -> tokenize(rest, [Minus, ..acc])
        "*" -> tokenize(rest, [Star, ..acc])
        "/" -> tokenize(rest, [Slash, ..acc])
        "(" -> tokenize(rest, [LParen, ..acc])
        ")" -> tokenize(rest, [RParen, ..acc])
        _ ->
          case is_digit(c) {
            True -> {
              let #(digits, remaining) = take_digits(chars, [])
              let s = string.concat(list.reverse(digits))
              let n = case int.parse(s) {
                Ok(v) -> v
                Error(_) -> 0
              }
              tokenize(remaining, [Num(n), ..acc])
            }
            False -> tokenize(rest, acc)
          }
      }
  }
}

fn is_digit(c: String) -> Bool {
  case c {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> True
    _ -> False
  }
}

fn take_digits(
  chars: List(String),
  acc: List(String),
) -> #(List(String), List(String)) {
  case chars {
    [c, ..rest] ->
      case is_digit(c) {
        True -> take_digits(rest, [c, ..acc])
        False -> #(acc, chars)
      }
    [] -> #(acc, chars)
  }
}

// ---------- recursive descent parser ----------

fn parse_expr(tokens: List(Token)) -> #(Int, List(Token)) {
  let #(lhs, rest) = parse_term(tokens)
  expr_tail(lhs, rest)
}

fn expr_tail(lhs: Int, tokens: List(Token)) -> #(Int, List(Token)) {
  case tokens {
    [Plus, ..rest] -> {
      let #(rhs, rest2) = parse_term(rest)
      expr_tail(lhs + rhs, rest2)
    }
    [Minus, ..rest] -> {
      let #(rhs, rest2) = parse_term(rest)
      expr_tail(lhs - rhs, rest2)
    }
    _ -> #(lhs, tokens)
  }
}

fn parse_term(tokens: List(Token)) -> #(Int, List(Token)) {
  let #(lhs, rest) = parse_factor(tokens)
  term_tail(lhs, rest)
}

fn term_tail(lhs: Int, tokens: List(Token)) -> #(Int, List(Token)) {
  case tokens {
    [Star, ..rest] -> {
      let #(rhs, rest2) = parse_factor(rest)
      term_tail(lhs * rhs, rest2)
    }
    [Slash, ..rest] -> {
      let #(rhs, rest2) = parse_factor(rest)
      term_tail(trunc_div(lhs, rhs), rest2)
    }
    _ -> #(lhs, tokens)
  }
}

fn trunc_div(a: Int, b: Int) -> Int {
  case b {
    0 -> 0
    _ -> {
      let q = int.absolute_value(a) / int.absolute_value(b)
      case { a < 0 } != { b < 0 } {
        True -> 0 - q
        False -> q
      }
    }
  }
}

fn parse_factor(tokens: List(Token)) -> #(Int, List(Token)) {
  case tokens {
    [Num(n), ..rest] -> #(n, rest)
    [LParen, ..rest] -> {
      let #(v, rest2) = parse_expr(rest)
      case rest2 {
        [RParen, ..rest3] -> #(v, rest3)
        _ -> #(v, rest2)
      }
    }
    [Minus, ..rest] -> {
      let #(v, rest2) = parse_factor(rest)
      #(0 - v, rest2)
    }
    [Plus, ..rest] -> parse_factor(rest)
    _ -> #(0, tokens)
  }
}

fn evaluate(line: String) -> Int {
  let tokens = tokenize(string.to_graphemes(line), [])
  let #(v, _) = parse_expr(tokens)
  v
}

// ---------- main ----------

fn loop() -> Nil {
  case read_line() {
    Error(_) -> Nil
    Ok(line) -> {
      let trimmed = string.trim(line)
      case trimmed {
        "" -> Nil
        _ -> io.println(int.to_string(evaluate(trimmed)))
      }
      loop()
    }
  }
}

pub fn main() {
  setopts([Binary])
  loop()
}
