import gleam/dynamic
import gleam/dynamic/decode
import gleam/erlang/atom
import gleam/int
import gleam/io
import gleam/list
import gleam/string

const values = [
  #(1000, "M"), #(900, "CM"), #(500, "D"), #(400, "CD"),
  #(100, "C"), #(90, "XC"), #(50, "L"), #(40, "XL"),
  #(10, "X"), #(9, "IX"), #(5, "V"), #(4, "IV"),
  #(1, "I"),
]

fn to_roman(n: Int) -> String {
  to_roman_loop(n, values, "")
}

fn to_roman_loop(n: Int, remaining: List(#(Int, String)), acc: String) -> String {
  case remaining {
    [] -> acc
    [#(value, symbol), ..rest] ->
      case n >= value {
        True -> to_roman_loop(n - value, remaining, acc <> symbol)
        False -> to_roman_loop(n, rest, acc)
      }
  }
}

@external(erlang, "io", "setopts")
fn io_setopts(device: atom.Atom, opts: List(atom.Atom)) -> Nil

@external(erlang, "io", "get_line")
fn io_get_line(device: atom.Atom, prompt: String) -> dynamic.Dynamic

fn set_binary_mode() -> Nil {
  let standard_io = atom.create("standard_io")
  let binary = atom.create("binary")
  io_setopts(standard_io, [binary])
}

fn get_line() -> Result(String, Nil) {
  let standard_io = atom.create("standard_io")
  let raw = io_get_line(standard_io, "")
  case decode.run(raw, decode.string) {
    Ok(line) -> Ok(line)
    Error(_) -> Error(Nil)
  }
}

fn read_all_lines() -> List(String) {
  read_lines_loop([])
}

fn read_lines_loop(acc: List(String)) -> List(String) {
  case get_line() {
    Ok(line) -> {
      let trimmed = string.trim(line)
      case trimmed {
        "" -> read_lines_loop(acc)
        _ -> read_lines_loop([trimmed, ..acc])
      }
    }
    Error(_) -> list.reverse(acc)
  }
}

pub fn main() {
  set_binary_mode()
  let lines = read_all_lines()
  lines
  |> list.each(fn(line) {
    case int.parse(line) {
      Ok(n) -> io.println(to_roman(n))
      Error(_) -> Nil
    }
  })
}
