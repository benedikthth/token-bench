import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/io
import gleam/list
import gleam/string

@external(erlang, "io", "get_line")
fn get_line(prompt: String) -> Dynamic

@external(erlang, "erlang", "is_binary")
fn is_binary(x: Dynamic) -> Bool

@external(erlang, "gleam_stdlib", "identity")
fn coerce(x: Dynamic) -> String

fn read_all(acc: List(String)) -> List(String) {
  let line = get_line("")
  case is_binary(line) {
    True -> read_all([coerce(line), ..acc])
    False -> list.reverse(acc)
  }
}

fn key(word: String) -> String {
  word
  |> string.to_graphemes
  |> list.sort(string.compare)
  |> string.concat
}

fn add(groups: Dict(String, List(String)), word: String) -> Dict(String, List(String)) {
  let k = key(word)
  case dict.get(groups, k) {
    Ok(ws) -> dict.insert(groups, k, [word, ..ws])
    Error(_) -> dict.insert(groups, k, [word])
  }
}

fn compare_groups(a: List(String), b: List(String)) {
  case a, b {
    [x, ..], [y, ..] -> string.compare(x, y)
    _, _ -> string.compare(string.concat(a), string.concat(b))
  }
}

pub fn main() {
  let words =
    read_all([])
    |> list.map(string.trim)
    |> list.filter(fn(w) { w != "" })

  let groups =
    words
    |> list.fold(dict.new(), add)
    |> dict.values
    |> list.map(fn(g) { list.sort(g, string.compare) })
    |> list.sort(compare_groups)

  list.each(groups, fn(g) { io.println(string.join(g, " ")) })
}
