import gleam/io
import gleam/list
import gleam/string
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode

@external(erlang, "io", "get_line")
fn erl_get_line(prompt: String) -> Dynamic

fn read_line() -> Result(String, Nil) {
  case decode.run(erl_get_line(""), decode.list(decode.int)) {
    Ok(codepoints) -> {
      let cps = list.filter_map(codepoints, string.utf_codepoint)
      Ok(string.from_utf_codepoints(cps))
    }
    Error(_) -> Error(Nil)
  }
}

pub fn main() {
  process_lines()
}

fn process_lines() -> Nil {
  case read_line() {
    Ok(line) -> {
      let trimmed = string.trim_end(line)
      case is_balanced(trimmed) {
        True -> io.println("yes")
        False -> io.println("no")
      }
      process_lines()
    }
    Error(_) -> Nil
  }
}

fn is_balanced(line: String) -> Bool {
  check(string.to_graphemes(line), [])
}

fn check(chars: List(String), stack: List(String)) -> Bool {
  case chars {
    [] -> list.is_empty(stack)
    [c, ..rest] ->
      case c {
        "(" -> check(rest, [")", ..stack])
        "[" -> check(rest, ["]", ..stack])
        "{" -> check(rest, ["}", ..stack])
        ")" | "]" | "}" ->
          case stack {
            [top, ..stack_rest] if top == c -> check(rest, stack_rest)
            _ -> False
          }
        _ -> check(rest, stack)
      }
  }
}
