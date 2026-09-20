import gleam/io
import gleam/int
import gleam/list
import gleam/string

type Dyn

@external(erlang, "io", "get_line")
fn get_line(prompt: String) -> Dyn

@external(erlang, "erlang", "is_atom")
fn is_atom(x: Dyn) -> Bool

@external(erlang, "unicode", "characters_to_binary")
fn to_binary(x: Dyn) -> String

fn read_line() -> String {
  let d = get_line("")
  case is_atom(d) {
    True -> ""
    False ->
      to_binary(d)
      |> string.replace("\r", "")
      |> string.replace("\n", "")
      |> string.trim
  }
}

fn step(
  c: String,
  bs: List(String),
  prev: List(Int),
  diag: Int,
  left: Int,
  acc: List(Int),
) -> List(Int) {
  case bs, prev {
    [b, ..bt], [p, ..pt] -> {
      let v = case b == c {
        True -> diag + 1
        False -> int.max(p, left)
      }
      step(c, bt, pt, p, v, [v, ..acc])
    }
    _, _ -> list.reverse(acc)
  }
}

pub fn main() {
  let a = string.to_graphemes(read_line())
  let b = string.to_graphemes(read_line())
  let row0 = list.map(b, fn(_) { 0 })
  let final =
    list.fold(a, row0, fn(prev, c) { step(c, b, prev, 0, 0, []) })
  let ans = case list.last(final) {
    Ok(v) -> v
    Error(_) -> 0
  }
  io.println(int.to_string(ans))
}
