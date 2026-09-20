import gleam/int
import gleam/io
import gleam/list
import gleam/string

@external(erlang, "io", "get_line")
fn erl_get_line(prompt: String) -> Dynamic

type Dynamic

@external(erlang, "erlang", "is_binary")
fn is_binary(x: Dynamic) -> Bool

fn read_all() -> String {
  read_loop([])
}

fn read_loop(acc: List(String)) -> String {
  let line = erl_get_line("")
  case is_binary(line) {
    True -> read_loop([coerce(line), ..acc])
    False -> acc |> list.reverse |> string.concat
  }
}

@external(erlang, "erlang", "iolist_to_binary")
fn coerce(x: Dynamic) -> String

const table = [
  #(1000, "M"),
  #(900, "CM"),
  #(500, "D"),
  #(400, "CD"),
  #(100, "C"),
  #(90, "XC"),
  #(50, "L"),
  #(40, "XL"),
  #(10, "X"),
  #(9, "IX"),
  #(5, "V"),
  #(4, "IV"),
  #(1, "I"),
]

fn to_roman(n: Int, entries: List(#(Int, String)), acc: String) -> String {
  case entries {
    [] -> acc
    [#(value, sym), ..rest] ->
      case n >= value {
        True -> to_roman(n - value, entries, acc <> sym)
        False -> to_roman(n, rest, acc)
      }
  }
}

pub fn main() {
  read_all()
  |> string.split("\n")
  |> list.map(string.trim)
  |> list.filter(fn(s) { s != "" })
  |> list.map(fn(s) {
    case int.parse(s) {
      Ok(n) -> to_roman(n, table, "")
      Error(_) -> ""
    }
  })
  |> list.each(io.println)
}
