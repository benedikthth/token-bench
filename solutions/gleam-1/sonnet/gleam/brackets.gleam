import gleam/dynamic.{type Dynamic}
import gleam/io
import gleam/list
import gleam/string

@external(erlang, "io", "get_line")
fn erl_get_line(prompt: String) -> Dynamic

@external(erlang, "erlang", "is_atom")
fn is_atom(value: Dynamic) -> Bool

@external(erlang, "unicode", "characters_to_binary")
fn to_str(value: Dynamic) -> String

fn read_line() -> Result(String, Nil) {
  let result = erl_get_line("")
  case is_atom(result) {
    True -> Error(Nil)
    False -> Ok(to_str(result))
  }
}

fn read_all_lines(acc: List(String)) -> List(String) {
  case read_line() {
    Ok(line) -> read_all_lines([line, ..acc])
    Error(Nil) -> list.reverse(acc)
  }
}

fn matches(open: String, close: String) -> Bool {
  case open, close {
    "(", ")" -> True
    "[", "]" -> True
    "{", "}" -> True
    _, _ -> False
  }
}

fn check(chars: List(String), stack: List(String)) -> Bool {
  case chars {
    [] -> stack == []
    [c, ..rest] ->
      case c {
        "(" | "[" | "{" -> check(rest, [c, ..stack])
        ")" | "]" | "}" ->
          case stack {
            [top, ..rest_stack] ->
              case matches(top, c) {
                True -> check(rest, rest_stack)
                False -> False
              }
            [] -> False
          }
        _ -> check(rest, stack)
      }
  }
}

fn is_balanced(line: String) -> Bool {
  check(string.to_graphemes(line), [])
}

pub fn main() {
  let lines = read_all_lines([])
  lines
  |> list.each(fn(line) {
    case is_balanced(line) {
      True -> io.println("yes")
      False -> io.println("no")
    }
  })
}
