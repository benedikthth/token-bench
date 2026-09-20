import gleam/io
import gleam/string
import gleam/list
import gleam/int
import gleam/result

@external(erlang, "io", "get_line")
fn get_line_ffi(prompt: String) -> String

pub fn main() {
  let first_line_raw = get_line_ffi("")
  let first_line = string.trim(first_line_raw)
  let parts = string.split(first_line, " ")

  let assert [r_str, c_str] = parts
  let assert Ok(r) = int.parse(r_str)
  let assert Ok(_c) = int.parse(c_str)

  // Read R lines
  let matrix = read_rows(r, [])

  // Transpose and output
  matrix
  |> transpose
  |> list.each(fn(row) {
    row
    |> list.map(int.to_string)
    |> string.join(" ")
    |> io.println()
  })
}

fn read_rows(count: Int, acc: List(List(Int))) -> List(List(Int)) {
  case count {
    0 -> list.reverse(acc)
    n -> {
      let line_raw = get_line_ffi("")
      let line = string.trim(line_raw)
      let row = string.split(line, " ")
        |> list.map(fn(s) {
          int.parse(s) |> result.unwrap(0)
        })
      read_rows(n - 1, [row, ..acc])
    }
  }
}

fn transpose(matrix: List(List(Int))) -> List(List(Int)) {
  case matrix {
    [] -> []
    _ -> {
      let firsts = list.filter_map(matrix, list.first)
      case firsts {
        [] -> []
        _ -> {
          let rests = list.filter_map(matrix, list.rest)
          [firsts, ..transpose(rests)]
        }
      }
    }
  }
}
