import gleam/io
import gleam/list
import gleam/string

fn is_balanced(line: String) -> Bool {
  let chars = string.split(line, "")
  is_balanced_helper(chars, [])
}

fn is_balanced_helper(
  chars: List(String),
  stack: List(String),
) -> Bool {
  case chars {
    [] -> list.is_empty(stack)
    [char, ..rest] ->
      case char {
        "(" | "[" | "{" -> is_balanced_helper(rest, [char, ..stack])
        ")" ->
          case stack {
            ["(", ..rest_stack] -> is_balanced_helper(rest, rest_stack)
            _ -> False
          }
        "]" ->
          case stack {
            ["[", ..rest_stack] -> is_balanced_helper(rest, rest_stack)
            _ -> False
          }
        "}" ->
          case stack {
            ["{", ..rest_stack] -> is_balanced_helper(rest, rest_stack)
            _ -> False
          }
        _ -> False
      }
  }
}

@external(erlang, "io", "get_line")
fn read_line_erlang(prompt: String) -> String

fn process_lines() -> Nil {
  let line = read_line_erlang("")
  case line {
    "eof" -> Nil
    _ -> {
      let trimmed = string.trim(line)
      let result = is_balanced(trimmed)
      io.println(case result {
        True -> "yes"
        False -> "no"
      })
      process_lines()
    }
  }
}

pub fn main() {
  process_lines()
}
