import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/int
import gleam/io
import gleam/list
import gleam/string

@external(erlang, "io", "get_line")
fn erl_get_line(prompt: String) -> Dynamic

fn read_line() -> String {
  let raw = erl_get_line("")
  let text = case decode.run(raw, decode.string) {
    Ok(s) -> s
    Error(_) -> ""
  }
  text
  |> string.replace("\r\n", "")
  |> string.replace("\n", "")
  |> string.replace("\r", "")
}

fn compute_row_loop(
  c1: String,
  diag: Int,
  prev_rest: List(Int),
  s2_chars: List(String),
  left: Int,
  acc: List(Int),
) -> List(Int) {
  case prev_rest, s2_chars {
    [up, ..prest], [ch, ..schars] -> {
      let new_val = case ch == c1 {
        True -> diag + 1
        False -> int.max(left, up)
      }
      compute_row_loop(c1, up, prest, schars, new_val, [new_val, ..acc])
    }
    _, _ -> list.reverse(acc)
  }
}

fn compute_row(c1: String, prev_row: List(Int), s2_chars: List(String)) -> List(Int) {
  case prev_row {
    [p0, ..rest] -> compute_row_loop(c1, p0, rest, s2_chars, 0, [0])
    [] -> [0]
  }
}

fn lcs_length(s1: String, s2: String) -> Int {
  let s1_chars = string.to_graphemes(s1)
  let s2_chars = string.to_graphemes(s2)
  let m = list.length(s2_chars)
  let row0 = list.repeat(0, m + 1)
  let final_row =
    list.fold(s1_chars, row0, fn(prev_row, c1) {
      compute_row(c1, prev_row, s2_chars)
    })
  case list.last(final_row) {
    Ok(v) -> v
    Error(_) -> 0
  }
}

pub fn main() {
  let line1 = read_line()
  let line2 = read_line()
  let result = lcs_length(line1, line2)
  io.println(int.to_string(result))
}
