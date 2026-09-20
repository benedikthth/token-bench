import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/order
import gleam/string

@external(erlang, "io", "get_line")
fn get_line(prompt: String) -> Dynamic

@external(erlang, "erlang", "is_binary")
fn is_binary(x: Dynamic) -> Bool

@external(erlang, "erlang", "iolist_to_binary")
fn to_binary(x: Dynamic) -> String

fn read_all(acc: List(String)) -> String {
  let line = get_line("")
  case is_binary(line) {
    True -> read_all([to_binary(line), ..acc])
    False -> acc |> list.reverse |> string.concat
  }
}

fn is_letter(c: String) -> Bool {
  case c {
    "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m"
    | "n" | "o" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z"
    | "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" | "L" | "M"
    | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z" ->
      True
    _ -> False
  }
}

fn tokenize(
  chars: List(String),
  current: List(String),
  counts: Dict(String, Int),
) -> Dict(String, Int) {
  case chars {
    [] -> flush(current, counts)
    [c, ..rest] ->
      case is_letter(c) {
        True -> tokenize(rest, [c, ..current], counts)
        False -> tokenize(rest, [], flush(current, counts))
      }
  }
}

fn flush(current: List(String), counts: Dict(String, Int)) -> Dict(String, Int) {
  case current {
    [] -> counts
    _ -> {
      let word = current |> list.reverse |> string.concat |> string.lowercase
      dict.upsert(counts, word, fn(v) {
        case v {
          Some(n) -> n + 1
          None -> 1
        }
      })
    }
  }
}

pub fn main() {
  let text = read_all([])
  let counts = tokenize(string.to_graphemes(text), [], dict.new())
  counts
  |> dict.to_list
  |> list.sort(fn(a, b) {
    case int.compare(b.1, a.1) {
      order.Eq -> string.compare(a.0, b.0)
      o -> o
    }
  })
  |> list.each(fn(p) { io.println(p.0 <> " " <> int.to_string(p.1)) })
}
