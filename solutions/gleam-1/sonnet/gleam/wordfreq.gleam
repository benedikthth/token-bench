import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/erlang/atom
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/order
import gleam/string

pub fn main() {
  read_all("")
  |> extract_words
  |> count_words
  |> sort_counts
  |> list.each(fn(pair) {
    io.println(pair.0 <> " " <> int.to_string(pair.1))
  })
}

@external(erlang, "io", "get_line")
fn get_line_raw(device: Dynamic, prompt: String) -> Dynamic

@external(erlang, "unicode", "characters_to_binary")
fn to_binary(data: Dynamic) -> Dynamic

fn read_all(acc: String) -> String {
  let device = atom.to_dynamic(atom.create("standard_io"))
  let raw = get_line_raw(device, "")
  let eof = atom.to_dynamic(atom.create("eof"))
  case raw == eof {
    True -> acc
    False -> {
      let bin = to_binary(raw)
      case decode.run(bin, decode.string) {
        Ok(s) -> read_all(acc <> s)
        Error(_) -> acc
      }
    }
  }
}

fn extract_words(text: String) -> List(String) {
  text
  |> string.to_utf_codepoints
  |> list.map(string.utf_codepoint_to_int)
  |> collect_words([], [])
}

fn collect_words(
  ints: List(Int),
  current: List(Int),
  words: List(String),
) -> List(String) {
  case ints {
    [] -> finish_word(current, words)
    [c, ..rest] ->
      case letter_value(c) {
        Ok(v) -> collect_words(rest, [v, ..current], words)
        Error(_) -> collect_words(rest, [], finish_word(current, words))
      }
  }
}

fn finish_word(current: List(Int), words: List(String)) -> List(String) {
  case current {
    [] -> words
    _ -> [codepoints_to_string(list.reverse(current)), ..words]
  }
}

fn letter_value(c: Int) -> Result(Int, Nil) {
  case c {
    _ if c >= 65 && c <= 90 -> Ok(c + 32)
    _ if c >= 97 && c <= 122 -> Ok(c)
    _ -> Error(Nil)
  }
}

fn codepoints_to_string(ints: List(Int)) -> String {
  ints
  |> list.map(fn(i) {
    case string.utf_codepoint(i) {
      Ok(cp) -> cp
      Error(_) -> panic as "invalid codepoint"
    }
  })
  |> string.from_utf_codepoints
}

fn count_words(words: List(String)) -> Dict(String, Int) {
  list.fold(words, dict.new(), fn(acc, w) {
    dict.upsert(acc, w, fn(existing) {
      case existing {
        Some(n) -> n + 1
        None -> 1
      }
    })
  })
}

fn sort_counts(counts: Dict(String, Int)) -> List(#(String, Int)) {
  counts
  |> dict.to_list
  |> list.sort(by: fn(a, b) {
    case int.compare(b.1, a.1) {
      order.Eq -> string.compare(a.0, b.0)
      other -> other
    }
  })
}
