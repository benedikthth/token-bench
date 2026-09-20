import gleam/dynamic.{type Dynamic}
import gleam/int
import gleam/io
import gleam/list
import gleam/string

@external(erlang, "io", "get_line")
fn raw_get_line(prompt: String) -> Dynamic

@external(erlang, "erlang", "is_atom")
fn is_atom(x: Dynamic) -> Bool

@external(erlang, "unicode", "characters_to_binary")
fn chars_to_binary(x: Dynamic) -> String

/// Read one line from stdin, without the trailing newline. Returns "" at EOF.
fn read_line() -> String {
  let raw = raw_get_line("")
  case is_atom(raw) {
    True -> ""
    False ->
      chars_to_binary(raw)
      |> string.trim_end
  }
}

fn max(a: Int, b: Int) -> Int {
  case a > b {
    True -> a
    False -> b
  }
}

/// Compute one DP row for character `ca` of the first string.
/// `bs` are the remaining chars of the second string, `prev` the remaining
/// entries of the previous row (aligned with `bs`), `diag` = prev[j-1],
/// `left` = cur[j-1]. The new row is accumulated in reverse.
fn next_row(
  ca: UtfCodepoint,
  bs: List(UtfCodepoint),
  prev: List(Int),
  diag: Int,
  left: Int,
  acc: List(Int),
) -> List(Int) {
  case bs, prev {
    [bj, ..brest], [up, ..prest] -> {
      let cur = case bj == ca {
        True -> diag + 1
        False -> max(up, left)
      }
      next_row(ca, brest, prest, up, cur, [cur, ..acc])
    }
    _, _ -> list.reverse(acc)
  }
}

fn lcs(a: List(UtfCodepoint), b: List(UtfCodepoint)) -> Int {
  let m = list.length(b)
  let initial = list.repeat(0, m + 1)
  let final_row =
    list.fold(a, initial, fn(prev, ca) {
      case prev {
        [_, ..prest] -> next_row(ca, b, prest, 0, 0, [0])
        [] -> prev
      }
    })
  case list.last(final_row) {
    Ok(v) -> v
    Error(_) -> 0
  }
}

pub fn main() {
  let a = read_line() |> string.to_utf_codepoints
  let b = read_line() |> string.to_utf_codepoints
  io.println(int.to_string(lcs(a, b)))
}
