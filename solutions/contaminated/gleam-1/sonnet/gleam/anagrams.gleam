import gleam/io
import gleam/list
import gleam/string
import gleam/dict
import gleam/dynamic.{type Dynamic}
import gleam/erlang/charlist
import gleam/option.{None, Some}

@external(erlang, "io", "get_line")
fn erl_get_line(prompt: String) -> Dynamic

@external(erlang, "erlang", "is_list")
fn erl_is_list(a: Dynamic) -> Bool

@external(erlang, "erlang", "is_binary")
fn erl_is_binary(a: Dynamic) -> Bool

@external(erlang, "gleam_stdlib", "identity")
fn unsafe_to_charlist(a: Dynamic) -> charlist.Charlist

@external(erlang, "gleam_stdlib", "identity")
fn unsafe_to_string(a: Dynamic) -> String

fn read_line() -> Result(String, Nil) {
  let raw = erl_get_line("")
  case erl_is_binary(raw) {
    True -> Ok(unsafe_to_string(raw))
    False ->
      case erl_is_list(raw) {
        True -> Ok(charlist.to_string(unsafe_to_charlist(raw)))
        False -> Error(Nil)
      }
  }
}

fn canonical_form(word: String) -> String {
  word
  |> string.to_graphemes
  |> list.sort(string.compare)
  |> string.concat
}

pub fn main() {
  read_all(dict.new())
  |> dict.values
  |> list.map(fn(group) { list.sort(group, string.compare) })
  |> list.sort(fn(a, b) {
    let assert [first_a, ..] = a
    let assert [first_b, ..] = b
    string.compare(first_a, first_b)
  })
  |> list.each(fn(group) {
    group
    |> string.join(" ")
    |> io.println
  })
}

fn read_all(
  acc: dict.Dict(String, List(String)),
) -> dict.Dict(String, List(String)) {
  case read_line() {
    Ok(line) -> {
      let word = string.trim(line)
      case word {
        "" -> read_all(acc)
        _ -> {
          let key = canonical_form(word)
          let updated =
            dict.upsert(acc, key, fn(existing) {
              case existing {
                Some(words) -> [word, ..words]
                None -> [word]
              }
            })
          read_all(updated)
        }
      }
    }
    Error(_) -> acc
  }
}
