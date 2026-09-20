import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/int
import gleam/io
import gleam/string

@external(erlang, "io", "get_line")
fn erl_get_line(prompt: String) -> Dynamic

fn read_line() -> Result(String, Nil) {
  case decode.run(erl_get_line(""), decode.string) {
    Ok(line) -> Ok(line)
    Error(_) -> Error(Nil)
  }
}

pub fn main() {
  process_lines()
}

fn process_lines() -> Nil {
  case read_line() {
    Error(_) -> Nil
    Ok(line) -> {
      let trimmed = string.trim(line)
      case trimmed {
        "" -> process_lines()
        _ -> {
          let chars = string.to_graphemes(trimmed)
          let #(value, _rest) = parse_expr(chars)
          io.println(int.to_string(value))
          process_lines()
        }
      }
    }
  }
}

// expr = term (('+' | '-') term)*
fn parse_expr(chars: List(String)) -> #(Int, List(String)) {
  let #(left, rest) = parse_term(chars)
  parse_expr_loop(left, rest)
}

fn parse_expr_loop(left: Int, chars: List(String)) -> #(Int, List(String)) {
  case skip_spaces(chars) {
    ["+", ..rest] -> {
      let #(right, rest2) = parse_term(skip_spaces(rest))
      parse_expr_loop(left + right, rest2)
    }
    ["-", ..rest] -> {
      let #(right, rest2) = parse_term(skip_spaces(rest))
      parse_expr_loop(left - right, rest2)
    }
    rest -> #(left, rest)
  }
}

// term = factor (('*' | '/') factor)*
fn parse_term(chars: List(String)) -> #(Int, List(String)) {
  let #(left, rest) = parse_factor(skip_spaces(chars))
  parse_term_loop(left, rest)
}

fn parse_term_loop(left: Int, chars: List(String)) -> #(Int, List(String)) {
  case skip_spaces(chars) {
    ["*", ..rest] -> {
      let #(right, rest2) = parse_factor(skip_spaces(rest))
      parse_term_loop(left * right, rest2)
    }
    ["/", ..rest] -> {
      let #(right, rest2) = parse_factor(skip_spaces(rest))
      parse_term_loop(left / right, rest2)
    }
    rest -> #(left, rest)
  }
}

// factor = number | '(' expr ')'
fn parse_factor(chars: List(String)) -> #(Int, List(String)) {
  case skip_spaces(chars) {
    ["(", ..rest] -> {
      let #(value, rest2) = parse_expr(rest)
      case skip_spaces(rest2) {
        [")", ..rest3] -> #(value, rest3)
        rest3 -> #(value, rest3)
      }
    }
    rest -> parse_number(rest)
  }
}

fn parse_number(chars: List(String)) -> #(Int, List(String)) {
  let #(digits, rest) = collect_digits(chars, "")
  case int.parse(digits) {
    Ok(n) -> #(n, rest)
    Error(_) -> #(0, rest)
  }
}

fn collect_digits(
  chars: List(String),
  acc: String,
) -> #(String, List(String)) {
  case chars {
    [d, ..rest] -> {
      case is_digit(d) {
        True -> collect_digits(rest, acc <> d)
        False -> #(acc, chars)
      }
    }
    [] -> #(acc, [])
  }
}

fn is_digit(s: String) -> Bool {
  case s {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> True
    _ -> False
  }
}

fn skip_spaces(chars: List(String)) -> List(String) {
  case chars {
    [" ", ..rest] -> skip_spaces(rest)
    _ -> chars
  }
}
