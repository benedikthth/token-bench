import gleam/dict
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/io
import gleam/list
import gleam/string

type Opt {
  Binary
}

@external(erlang, "io", "setopts")
fn setopts(opts: List(Opt)) -> Dynamic

@external(erlang, "io", "get_line")
fn get_line(prompt: String) -> Dynamic

fn read_lines(acc: List(String)) -> List(String) {
  case decode.run(get_line(""), decode.string) {
    Ok(line) -> read_lines([line, ..acc])
    Error(_) -> list.reverse(acc)
  }
}

pub fn main() {
  let _ = setopts([Binary])
  let words =
    read_lines([])
    |> list.map(string.trim)
    |> list.filter(fn(w) { w != "" })
  let groups =
    words
    |> list.group(fn(w) {
      w |> string.to_graphemes |> list.sort(string.compare) |> string.concat
    })
    |> dict.values
    |> list.map(fn(g) { list.sort(g, string.compare) })
    |> list.sort(fn(a, b) {
      case a, b {
        [x, ..], [y, ..] -> string.compare(x, y)
        _, _ -> string.compare("", "")
      }
    })
  groups
  |> list.each(fn(g) { io.println(string.join(g, " ")) })
}
