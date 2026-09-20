import gleam/int
import gleam/io
import gleam/list
import gleam/string

type Raw

@external(erlang, "io", "get_line")
fn get_line(prompt: String) -> Raw

@external(erlang, "erlang", "is_atom")
fn is_atom(x: Raw) -> Bool

@external(erlang, "unicode", "characters_to_binary")
fn to_binary(x: Raw) -> String

type Tok {
  Num(Int)
  Op(String)
}

fn tokenize(cs: List(String), acc: List(Tok)) -> List(Tok) {
  case cs {
    [] -> list.reverse(acc)
    [c, ..rest] ->
      case int.parse(c) {
        Ok(d) ->
          case acc {
            [Num(n), ..more] -> tokenize(rest, [Num(n * 10 + d), ..more])
            _ -> tokenize(rest, [Num(d), ..acc])
          }
        Error(_) ->
          case c {
            "+" | "-" | "*" | "/" | "(" | ")" ->
              tokenize(rest, [Op(c), Op(""), ..acc])
            _ -> tokenize(rest, [Op(""), ..acc])
          }
      }
  }
}

fn clean(ts: List(Tok)) -> List(Tok) {
  list.filter(ts, fn(t) { t != Op("") })
}

fn expr(ts: List(Tok)) -> #(Int, List(Tok)) {
  let #(v, rest) = term(ts)
  expr_loop(v, rest)
}

fn expr_loop(acc: Int, ts: List(Tok)) -> #(Int, List(Tok)) {
  case ts {
    [Op("+"), ..rest] -> {
      let #(v, r) = term(rest)
      expr_loop(acc + v, r)
    }
    [Op("-"), ..rest] -> {
      let #(v, r) = term(rest)
      expr_loop(acc - v, r)
    }
    _ -> #(acc, ts)
  }
}

fn term(ts: List(Tok)) -> #(Int, List(Tok)) {
  let #(v, rest) = factor(ts)
  term_loop(v, rest)
}

fn term_loop(acc: Int, ts: List(Tok)) -> #(Int, List(Tok)) {
  case ts {
    [Op("*"), ..rest] -> {
      let #(v, r) = factor(rest)
      term_loop(acc * v, r)
    }
    [Op("/"), ..rest] -> {
      let #(v, r) = factor(rest)
      term_loop(acc / v, r)
    }
    _ -> #(acc, ts)
  }
}

fn factor(ts: List(Tok)) -> #(Int, List(Tok)) {
  case ts {
    [Num(n), ..rest] -> #(n, rest)
    [Op("("), ..rest] -> {
      let #(v, r) = expr(rest)
      case r {
        [Op(")"), ..r2] -> #(v, r2)
        _ -> #(v, r)
      }
    }
    _ -> #(0, ts)
  }
}

fn main_loop() -> Nil {
  let raw = get_line("")
  case is_atom(raw) {
    True -> Nil
    False -> {
      let line = string.trim(to_binary(raw))
      case line {
        "" -> Nil
        _ -> {
          let toks = clean(tokenize(string.to_graphemes(line), []))
          let #(v, _) = expr(toks)
          io.println(int.to_string(v))
        }
      }
      main_loop()
    }
  }
}

pub fn main() {
  main_loop()
}
