import gleam/int
import gleam/io
import gleam/list
import gleam/string

type Dyn

type Atom

@external(erlang, "erlang", "binary_to_atom")
fn to_atom(s: String) -> Atom

@external(erlang, "io", "setopts")
fn setopts(dev: Atom, opts: List(Atom)) -> Dyn

@external(erlang, "io", "get_line")
fn get_line(dev: Atom, prompt: String) -> Dyn

@external(erlang, "erlang", "is_binary")
fn is_binary(x: Dyn) -> Bool

@external(erlang, "unicode", "characters_to_binary")
fn to_string(x: Dyn) -> String

fn read_line() -> String {
  let dev = to_atom("standard_io")
  setopts(dev, [to_atom("binary")])
  let r = get_line(dev, "")
  case is_binary(r) {
    True -> to_string(r)
    False -> ""
  }
}

fn encode(chars: List(String), acc: List(String)) -> List(String) {
  case chars {
    [] -> acc
    [c, ..] -> {
      let n = count(chars, c, 0)
      encode(list.drop(chars, n), [c <> int.to_string(n), ..acc])
    }
  }
}

fn count(chars: List(String), c: String, n: Int) -> Int {
  case chars {
    [x, ..rest] if x == c -> count(rest, c, n + 1)
    _ -> n
  }
}

pub fn main() {
  let s = string.trim(read_line())
  let out = encode(string.to_graphemes(s), []) |> list.reverse |> string.concat
  io.println(out)
}
