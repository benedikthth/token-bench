import gleam/dict
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string

@external(erlang, "io", "get_line")
fn erl_get_line(prompt: String) -> Dynamic

fn read_line() -> Result(String, Nil) {
  let value = erl_get_line("")
  case decode.run(value, decode.string) {
    Ok(line) -> Ok(line)
    Error(_) -> Error(Nil)
  }
}

fn read_all_lines(acc: List(String)) -> List(String) {
  case read_line() {
    Ok(line) -> {
      let trimmed = string.trim(line)
      case trimmed {
        "" -> read_all_lines(acc)
        _ -> read_all_lines([trimmed, ..acc])
      }
    }
    Error(Nil) -> list.reverse(acc)
  }
}

fn sort_key(word: String) -> String {
  word
  |> string.to_graphemes
  |> list.sort(string.compare)
  |> string.join("")
}

pub fn main() {
  let words = read_all_lines([])

  let groups =
    list.fold(words, dict.new(), fn(acc, word) {
      let key = sort_key(word)
      dict.upsert(acc, key, fn(existing) {
        case existing {
          Some(ws) -> [word, ..ws]
          None -> [word]
        }
      })
    })

  let group_lists =
    dict.values(groups)
    |> list.map(fn(ws) { list.sort(list.reverse(ws), string.compare) })
    |> list.sort(fn(a, b) {
      let assert [fa, ..] = a
      let assert [fb, ..] = b
      string.compare(fa, fb)
    })

  group_lists
  |> list.each(fn(ws) { io.println(string.join(ws, " ")) })
}
