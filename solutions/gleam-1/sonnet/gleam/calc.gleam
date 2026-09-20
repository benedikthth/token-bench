import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  loop()
}

fn loop() -> Nil {
  case read_line() {
    Error(_) -> Nil
    Ok(line) -> {
      let trimmed = string.trim(line)
      case trimmed {
        "" -> loop()
        _ -> {
          let tokens = tokenize(trimmed)
          let #(value, _rest) = parse_expr(tokens)
          io.println(int.to_string(value))
          loop()
        }
      }
    }
  }
}

@external(erlang, "io", "get_line")
fn get_line_raw(prompt: String) -> Dynamic

fn read_line() -> Result(String, Nil) {
  let data = get_line_raw("")
  case decode.run(data, decode.string) {
    Ok(s) -> Ok(s)
    Error(_) ->
      case decode.run(data, decode.list(decode.int)) {
        Ok(codepoints) -> {
          let cps = list.filter_map(codepoints, string.utf_codepoint)
          Ok(string.from_utf_codepoints(cps))
        }
        Error(_) -> Error(Nil)
      }
  }
}

pub type Token {
  TInt(Int)
  TPlus
  TMinus
  TStar
  TSlash
  TLParen
  TRParen
}

fn tokenize(s: String) -> List(Token) {
  tokenize_loop(s, [])
  |> list.reverse
}

fn tokenize_loop(s: String, acc: List(Token)) -> List(Token) {
  case string.pop_grapheme(s) {
    Error(_) -> acc
    Ok(#(g, rest)) ->
      case g {
        " " -> tokenize_loop(rest, acc)
        "+" -> tokenize_loop(rest, [TPlus, ..acc])
        "-" -> tokenize_loop(rest, [TMinus, ..acc])
        "*" -> tokenize_loop(rest, [TStar, ..acc])
        "/" -> tokenize_loop(rest, [TSlash, ..acc])
        "(" -> tokenize_loop(rest, [TLParen, ..acc])
        ")" -> tokenize_loop(rest, [TRParen, ..acc])
        _ -> {
          let #(num_str, rest2) = take_digits(s, "")
          let assert Ok(n) = int.parse(num_str)
          tokenize_loop(rest2, [TInt(n), ..acc])
        }
      }
  }
}

fn take_digits(s: String, acc: String) -> #(String, String) {
  case string.pop_grapheme(s) {
    Ok(#(g, rest)) ->
      case is_digit(g) {
        True -> take_digits(rest, acc <> g)
        False -> #(acc, s)
      }
    Error(_) -> #(acc, s)
  }
}

fn is_digit(g: String) -> Bool {
  case g {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> True
    _ -> False
  }
}

fn parse_expr(tokens: List(Token)) -> #(Int, List(Token)) {
  let #(v0, rest0) = parse_term(tokens)
  parse_expr_loop(v0, rest0)
}

fn parse_expr_loop(acc: Int, tokens: List(Token)) -> #(Int, List(Token)) {
  case tokens {
    [TPlus, ..rest] -> {
      let #(v, rest2) = parse_term(rest)
      parse_expr_loop(acc + v, rest2)
    }
    [TMinus, ..rest] -> {
      let #(v, rest2) = parse_term(rest)
      parse_expr_loop(acc - v, rest2)
    }
    _ -> #(acc, tokens)
  }
}

fn parse_term(tokens: List(Token)) -> #(Int, List(Token)) {
  let #(v0, rest0) = parse_factor(tokens)
  parse_term_loop(v0, rest0)
}

fn parse_term_loop(acc: Int, tokens: List(Token)) -> #(Int, List(Token)) {
  case tokens {
    [TStar, ..rest] -> {
      let #(v, rest2) = parse_factor(rest)
      parse_term_loop(acc * v, rest2)
    }
    [TSlash, ..rest] -> {
      let #(v, rest2) = parse_factor(rest)
      parse_term_loop(acc / v, rest2)
    }
    _ -> #(acc, tokens)
  }
}

fn parse_factor(tokens: List(Token)) -> #(Int, List(Token)) {
  case tokens {
    [TInt(n), ..rest] -> #(n, rest)
    [TLParen, ..rest] -> {
      let #(v, rest2) = parse_expr(rest)
      case rest2 {
        [TRParen, ..rest3] -> #(v, rest3)
        _ -> #(v, rest2)
      }
    }
    _ -> #(0, tokens)
  }
}
