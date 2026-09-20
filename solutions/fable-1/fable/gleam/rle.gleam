import gleam/int
import gleam/io
import gleam/list
import gleam/string

@external(erlang, "io", "get_line")
fn get_line(prompt: String) -> Dynamic

type Dynamic

@external(erlang, "erlang", "is_binary")
fn is_binary(x: Dynamic) -> Bool

@external(erlang, "erlang", "list_to_binary")
fn list_to_binary(x: Dynamic) -> String

@external(erlang, "erlang", "is_list")
fn is_list(x: Dynamic) -> Bool

fn read_line() -> String {
  let d = get_line("")
  case is_binary(d) {
    True -> unsafe_coerce(d)
    False ->
      case is_list(d) {
        True -> list_to_binary(d)
        False -> ""
      }
  }
}

@external(erlang, "gleam_stdlib", "identity")
fn unsafe_coerce(x: Dynamic) -> String

fn encode(chars: List(String), acc: List(String)) -> String {
  case chars {
    [] -> acc |> list.reverse |> string.concat
    [c, ..rest] -> {
      let #(run, remaining) = take_run(rest, c, 1)
      encode(remaining, [c <> int.to_string(run), ..acc])
    }
  }
}

fn take_run(chars: List(String), c: String, n: Int) -> #(Int, List(String)) {
  case chars {
    [x, ..rest] if x == c -> take_run(rest, c, n + 1)
    _ -> #(n, chars)
  }
}

pub fn main() {
  let line =
    read_line()
    |> string.trim
  io.println(encode(string.to_graphemes(line), []))
}
