import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/order
import gleam/string

pub type Line

@external(erlang, "io", "get_line")
fn get_line(prompt: String) -> Line

@external(erlang, "erlang", "is_atom")
fn is_atom(x: Line) -> Bool

@external(erlang, "unicode", "characters_to_binary")
fn to_binary(x: Line) -> String

fn read_all(acc: List(String)) -> String {
  let l = get_line("")
  case is_atom(l) {
    True -> string.concat(list.reverse(acc))
    False -> read_all([to_binary(l), ..acc])
  }
}

fn is_letter(c: String) -> Bool {
  case string.to_utf_codepoints(c) {
    [cp] -> {
      let n = string.utf_codepoint_to_int(cp)
      { n >= 65 && n <= 90 } || { n >= 97 && n <= 122 }
    }
    _ -> False
  }
}

fn add(counts, cur: List(String)) {
  case cur {
    [] -> counts
    _ -> {
      let w = string.lowercase(string.concat(list.reverse(cur)))
      dict.upsert(counts, w, fn(o) {
        case o {
          option.None -> 1
          option.Some(n) -> n + 1
        }
      })
    }
  }
}

pub fn main() {
  let text = read_all([])
  let #(counts, cur) =
    string.to_utf_codepoints(text) |> list.map(fn(cp) { string.from_utf_codepoints([cp]) })
    |> list.fold(#(dict.new(), []), fn(st, c) {
      let #(counts, cur) = st
      case is_letter(c) {
        True -> #(counts, [c, ..cur])
        False -> #(add(counts, cur), [])
      }
    })
  let counts = add(counts, cur)
  dict.to_list(counts)
  |> list.sort(fn(a, b) {
    case int.compare(b.1, a.1) {
      order.Eq -> string.compare(a.0, b.0)
      o -> o
    }
  })
  |> list.each(fn(p) { io.println(p.0 <> " " <> int.to_string(p.1)) })
}
