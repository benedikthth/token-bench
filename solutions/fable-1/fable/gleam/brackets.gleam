import gleam/dynamic.{type Dynamic}
import gleam/io
import gleam/string

@external(erlang, "io", "get_line")
fn raw_get_line(prompt: String) -> Dynamic

@external(erlang, "unicode", "characters_to_binary")
fn to_binary(data: Dynamic) -> String

fn get_line() -> Result(String, Nil) {
  let raw = raw_get_line("")
  case dynamic.classify(raw) {
    "Atom" -> Error(Nil)
    _ -> Ok(to_binary(raw))
  }
}

fn balanced(chars: List(String), stack: List(String)) -> Bool {
  case chars, stack {
    [], [] -> True
    [], _ -> False
    ["(", ..rest], _ -> balanced(rest, [")", ..stack])
    ["[", ..rest], _ -> balanced(rest, ["]", ..stack])
    ["{", ..rest], _ -> balanced(rest, ["}", ..stack])
    [c, ..rest], [top, ..stack_rest] if c == top -> balanced(rest, stack_rest)
    _, _ -> False
  }
}

fn loop() -> Nil {
  case get_line() {
    Error(Nil) -> Nil
    Ok(line) -> {
      let line =
        line
        |> string.replace("\n", "")
        |> string.replace("\r", "")
      case balanced(string.to_graphemes(line), []) {
        True -> io.println("yes")
        False -> io.println("no")
      }
      loop()
    }
  }
}

pub fn main() {
  loop()
}
