import gleam/io
import gleam/string
import gleam/int

@external(erlang, "io", "get_line")
fn read_line(prompt: String) -> String

pub fn main() {
  let line = read_line("")
  let trimmed = string.trim_end(line)
  let encoded = run_length_encode(trimmed)
  io.println(encoded)
}

fn run_length_encode(input: String) -> String {
  let chars = string.split(input, "")
  process_chars(chars, "", 0, "")
}

fn process_chars(
  chars: List(String),
  current_char: String,
  count: Int,
  acc: String,
) -> String {
  case chars {
    [] -> {
      case current_char {
        "" -> acc
        _ -> acc <> current_char <> int.to_string(count)
      }
    }
    [ch, ..rest] -> {
      case current_char {
        "" -> process_chars(rest, ch, 1, acc)
        _ -> {
          case ch == current_char {
            True -> process_chars(rest, current_char, count + 1, acc)
            False -> {
              let new_acc = acc <> current_char <> int.to_string(count)
              process_chars(rest, ch, 1, new_acc)
            }
          }
        }
      }
    }
  }
}
