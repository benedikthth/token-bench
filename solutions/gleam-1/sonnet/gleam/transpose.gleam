import gleam/dynamic
import gleam/int
import gleam/io
import gleam/list
import gleam/string

@external(erlang, "io", "get_line")
fn erl_get_line(prompt: String) -> dynamic.Dynamic

@external(erlang, "unicode", "characters_to_binary")
fn chars_to_string(a: dynamic.Dynamic) -> String

fn read_line() -> Result(String, Nil) {
  let raw = erl_get_line("")
  case dynamic.classify(raw) {
    "Atom" -> Error(Nil)
    _ -> Ok(chars_to_string(raw))
  }
}

fn parse_ints(line: String) -> List(Int) {
  line
  |> string.trim
  |> string.split(" ")
  |> list.filter(fn(s) { s != "" })
  |> list.map(fn(s) {
    let assert Ok(v) = int.parse(s)
    v
  })
}

pub fn main() {
  let assert Ok(first_line) = read_line()
  let assert [r, c] = parse_ints(first_line)

  let rows = read_rows(r)

  case r {
    0 -> list.each(repeat_nil(c), fn(_) { io.println("") })
    _ ->
      transpose(rows)
      |> list.each(fn(row) {
        io.println(row |> list.map(int.to_string) |> string.join(" "))
      })
  }
}

fn repeat_nil(c: Int) -> List(Nil) {
  case c {
    n if n <= 0 -> []
    n -> [Nil, ..repeat_nil(n - 1)]
  }
}

fn read_rows(n: Int) -> List(List(Int)) {
  case n {
    0 -> []
    _ -> {
      let assert Ok(line) = read_line()
      let nums = parse_ints(line)
      [nums, ..read_rows(n - 1)]
    }
  }
}

fn transpose(rows: List(List(Int))) -> List(List(Int)) {
  case rows {
    [] -> []
    [[], ..] -> []
    _ -> {
      let heads =
        list.map(rows, fn(row) {
          let assert [h, ..] = row
          h
        })
      let tails =
        list.map(rows, fn(row) {
          let assert [_, ..t] = row
          t
        })
      [heads, ..transpose(tails)]
    }
  }
}
