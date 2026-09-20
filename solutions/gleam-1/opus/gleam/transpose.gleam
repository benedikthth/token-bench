import gleam/dynamic.{type Dynamic}
import gleam/io
import gleam/list
import gleam/string

@external(erlang, "io", "get_line")
fn get_line(prompt: String) -> Dynamic

@external(erlang, "erlang", "is_atom")
fn is_atom(x: Dynamic) -> Bool

@external(erlang, "unicode", "characters_to_binary")
fn to_binary(x: Dynamic) -> String

fn read_all(acc: List(String)) -> List(String) {
  let l = get_line("")
  case is_atom(l) {
    True -> list.reverse(acc)
    False -> read_all([to_binary(l), ..acc])
  }
}

pub fn main() {
  let lines =
    read_all([])
    |> list.map(string.trim)
    |> list.filter(fn(s) { s != "" })
  case lines {
    [header, ..rest] -> {
      let nums = string.split(header, " ") |> list.filter(fn(s) { s != "" })
      let assert [_, c] = nums
      let rows =
        list.map(rest, fn(r) {
          string.split(r, " ") |> list.filter(fn(s) { s != "" })
        })
      case c == "0" || rows == [] {
        True -> Nil
        False ->
          list.transpose(rows)
          |> list.each(fn(col) { io.println(string.join(col, " ")) })
      }
    }
    [] -> Nil
  }
}
