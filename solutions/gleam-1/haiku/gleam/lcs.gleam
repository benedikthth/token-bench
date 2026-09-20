import gleam/string
import gleam/list
import gleam/int

// External declarations to read from Erlang I/O
@external(erlang, "io", "get_line")
fn io_get_line(prompt: String) -> String

pub fn main() {
  // Read two lines from stdin
  let s1 = io_get_line("")
  let s2 = io_get_line("")

  // Strip newlines
  let s1_clean = string.trim_end(s1)
  let s2_clean = string.trim_end(s2)

  let result = lcs_length(s1_clean, s2_clean)
  erlang_print_int(result)
}

@external(erlang, "io", "fwrite")
fn erlang_format(format: String, args: List(a)) -> Nil

fn erlang_print_int(n: Int) {
  erlang_format("~w~n", [n])
}

fn lcs_length(s1: String, s2: String) -> Int {
  let len1 = string.length(s1)
  let len2 = string.length(s2)

  // Start with row 0: all zeros
  let initial_row = list.repeat(0, len2 + 1)

  // Compute rows 1 to len1 using recursion
  fill_rows(s1, s2, 0, len1, len2, initial_row)
  |> list.last
  |> fn(r) {
    case r {
      Ok(v) -> v
      Error(_) -> 0
    }
  }
}

fn fill_rows(s1, s2, i, len1, len2, prev_row) {
  case i >= len1 {
    True -> prev_row
    False -> {
      let s1_char = string.slice(s1, i, 1)
      let new_row = compute_row_values(s2, s1_char, len2, prev_row, 0, [])
      fill_rows(s1, s2, i + 1, len1, len2, new_row)
    }
  }
}

fn compute_row_values(s2, s1_char, len2, prev_row, j, acc) {
  case j > len2 {
    True -> list.reverse(acc)
    False -> {
      let val = case j {
        0 -> 0
        _ -> {
          let s2_char = string.slice(s2, j - 1, 1)
          case s1_char == s2_char {
            True -> {
              // Characters match: take diagonal + 1
              let diag = get_list_item(prev_row, j - 1, 0)
              diag + 1
            }
            False -> {
              // Characters don't match: take max of up and left
              let up = get_list_item(prev_row, j, 0)
              let left = list.last(acc)
              |> fn(r) {
                case r {
                  Ok(v) -> v
                  Error(_) -> 0
                }
              }
              case up > left {
                True -> up
                False -> left
              }
            }
          }
        }
      }
      compute_row_values(s2, s1_char, len2, prev_row, j + 1, [val, ..acc])
    }
  }
}

fn get_list_item(lst, index, default) {
  // Implement list.at using pattern matching and recursion
  get_item_helper(lst, index, 0, default)
}

fn get_item_helper(lst, target_index, current_index, default) {
  case lst {
    [] -> default
    [h, ..t] -> {
      case current_index == target_index {
        True -> h
        False -> get_item_helper(t, target_index, current_index + 1, default)
      }
    }
  }
}
