import gleam/int
import gleam/io
import gleam/string

pub type Raw

@external(erlang, "io", "get_line")
fn get_line(prompt: String) -> Raw

@external(erlang, "erlang", "is_list")
fn is_list(r: Raw) -> Bool

@external(erlang, "erlang", "is_binary")
fn is_binary(r: Raw) -> Bool

@external(erlang, "unicode", "characters_to_binary")
fn to_string(r: Raw) -> String

const table = [
  #(1000, "M"), #(900, "CM"), #(500, "D"), #(400, "CD"), #(100, "C"),
  #(90, "XC"), #(50, "L"), #(40, "XL"), #(10, "X"), #(9, "IX"), #(5, "V"),
  #(4, "IV"), #(1, "I"),
]

fn roman(n: Int, t: List(#(Int, String)), acc: String) -> String {
  case t {
    [] -> acc
    [#(v, s), ..rest] ->
      case n >= v {
        True -> roman(n - v, t, acc <> s)
        False -> roman(n, rest, acc)
      }
  }
}

fn loop() -> Nil {
  let r = get_line("")
  case is_list(r) || is_binary(r) {
    False -> Nil
    True -> {
      case int.parse(string.trim(to_string(r))) {
        Ok(n) -> io.println(roman(n, table, ""))
        Error(_) -> Nil
      }
      loop()
    }
  }
}

pub fn main() {
  loop()
}
