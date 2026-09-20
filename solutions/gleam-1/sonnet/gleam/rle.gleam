import gleam/dynamic
import gleam/erlang/atom
import gleam/erlang/charlist.{type Charlist}
import gleam/int
import gleam/io
import gleam/string

@external(erlang, "io", "get_line")
fn erl_get_line(prompt: String) -> dynamic.Dynamic

@external(erlang, "gleam_erlang_ffi", "identity")
fn dynamic_to_charlist(d: dynamic.Dynamic) -> Charlist

pub fn main() {
  let line_dyn = erl_get_line("")
  let eof = atom.to_dynamic(atom.create("eof"))

  let line = case line_dyn == eof {
    True -> ""
    False -> charlist.to_string(dynamic_to_charlist(line_dyn))
  }

  let trimmed = string.trim_end(line)

  io.println(encode(trimmed))
}

fn encode(s: String) -> String {
  case string.to_graphemes(s) {
    [] -> ""
    [first, ..rest] -> encode_loop(rest, first, 1, "")
  }
}

fn encode_loop(
  chars: List(String),
  current: String,
  count: Int,
  acc: String,
) -> String {
  case chars {
    [] -> acc <> current <> int.to_string(count)
    [c, ..rest] ->
      case c == current {
        True -> encode_loop(rest, current, count + 1, acc)
        False ->
          encode_loop(rest, c, 1, acc <> current <> int.to_string(count))
      }
  }
}
