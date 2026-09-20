import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub type Chars

@external(erlang, "io", "get_line")
fn get_line(prompt: String) -> Chars

@external(erlang, "unicode", "characters_to_binary")
fn to_binary(c: Chars) -> String

fn is_prime(n: Int, d: Int) -> Bool {
  case d * d > n {
    True -> True
    False ->
      case n % d == 0 {
        True -> False
        False -> is_prime(n, d + 1)
      }
  }
}

fn collect(i: Int, acc: List(Int)) -> List(Int) {
  case i < 2 {
    True -> acc
    False ->
      case is_prime(i, 2) {
        True -> collect(i - 1, [i, ..acc])
        False -> collect(i - 1, acc)
      }
  }
}

pub fn main() {
  let line = to_binary(get_line(""))
  let n = case int.parse(string.trim(line)) {
    Ok(v) -> v
    Error(_) -> 0
  }
  collect(n, [])
  |> list.map(int.to_string)
  |> string.join(" ")
  |> io.println
}
