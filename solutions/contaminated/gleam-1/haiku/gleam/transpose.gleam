import gleam/io
import gleam/list
import gleam/string
import gleam/int

pub fn main() {
  // Read first line with R and C
  let assert Ok(first_line) = io.read_line("")
  let [r_str, c_str] = string.split(string.trim(first_line), " ")
  let assert Ok(r) = int.parse(r_str)
  let assert Ok(_c) = int.parse(c_str)

  // Read R lines of matrix
  let matrix = read_lines(r)

  // Transpose
  let transposed = transpose(matrix)

  // Output
  output_matrix(transposed)
}

fn read_lines(n: Int) -> List(List(Int)) {
  case n {
    0 -> []
    _ -> {
      let assert Ok(line) = io.read_line("")
      let row = line
        |> string.trim
        |> string.split(" ")
        |> list.map(fn(s) {
          let assert Ok(num) = int.parse(s)
          num
        })
      [row, ..read_lines(n - 1)]
    }
  }
}

fn transpose(matrix: List(List(Int))) -> List(List(Int)) {
  case matrix {
    [] -> []
    _ -> {
      let heads = list.filter_map(matrix, fn(row) {
        case row {
          [h | _] -> Ok(h)
          [] -> Error(Nil)
        }
      })
      case heads {
        [] -> []
        _ -> {
          let tails = list.filter_map(matrix, fn(row) {
            case row {
              [_ | t] -> Ok(t)
              [] -> Error(Nil)
            }
          })
          [heads, ..transpose(tails)]
        }
      }
    }
  }
}

fn output_matrix(matrix: List(List(Int))) -> Nil {
  case matrix {
    [] -> Nil
    [row | rest] -> {
      io.println(string.join(list.map(row, int.to_string), " "))
      output_matrix(rest)
    }
  }
}
