import gleam/dynamic.{type Dynamic}
import gleam/io
import gleam/list
import gleam/string

@external(erlang, "io", "get_line")
fn raw_get_line(prompt: String) -> Dynamic

@external(erlang, "unicode", "characters_to_binary")
fn to_binary(data: Dynamic) -> String

fn get_line() -> Result(String, Nil) {
  let line = raw_get_line("")
  case dynamic.classify(line) {
    "Atom" -> Error(Nil)
    _ -> Ok(to_binary(line))
  }
}

fn read_all(acc: List(String)) -> List(String) {
  case get_line() {
    Ok(line) -> read_all([line, ..acc])
    Error(_) -> list.reverse(acc)
  }
}

fn tokens(line: String) -> List(String) {
  line
  |> string.trim
  |> string.split(" ")
  |> list.filter(fn(s) { s != "" })
}

fn transpose(rows: List(List(String))) -> List(List(String)) {
  case rows {
    [] -> []
    [first, ..] ->
      case first {
        [] -> []
        _ -> {
          let heads = list.filter_map(rows, list.first)
          let tails = list.filter_map(rows, list.rest)
          [heads, ..transpose(tails)]
        }
      }
  }
}

pub fn main() {
  let lines = read_all([])
  let rows =
    lines
    |> list.drop(1)
    |> list.map(tokens)
    |> list.filter(fn(r) { r != [] })
  rows
  |> transpose
  |> list.each(fn(col) { io.println(string.join(col, " ")) })
}
