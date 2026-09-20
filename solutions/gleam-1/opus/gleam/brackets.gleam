import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/io
import gleam/string

type IoOpt {
  Binary
}

@external(erlang, "io", "setopts")
fn setopts(opts: List(IoOpt)) -> Dynamic

@external(erlang, "io", "get_line")
fn get_line(prompt: String) -> Dynamic

fn check(chars: List(String), stack: List(String)) -> Bool {
  case chars, stack {
    [], [] -> True
    [], _ -> False
    ["(", ..rest], _ -> check(rest, [")", ..stack])
    ["[", ..rest], _ -> check(rest, ["]", ..stack])
    ["{", ..rest], _ -> check(rest, ["}", ..stack])
    [c, ..rest], [top, ..st] if c == top -> check(rest, st)
    [c, ..rest], _ ->
      case c {
        ")" | "]" | "}" -> False
        _ -> check(rest, stack)
      }
  }
}

fn loop() -> Nil {
  case decode.run(get_line(""), decode.string) {
    Ok(line) -> {
      let chars = string.to_graphemes(string.trim(line))
      case check(chars, []) {
        True -> io.println("yes")
        False -> io.println("no")
      }
      loop()
    }
    Error(_) -> Nil
  }
}

pub fn main() {
  setopts([Binary])
  loop()
}
