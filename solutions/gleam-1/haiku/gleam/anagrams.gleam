import gleam/io
import gleam/list
import gleam/string
import gleam/dict
import gleam/order
import gleam/option.{Some, None}

@external(erlang, "solution_ffi", "read_line")
fn read_line_external() -> Result(String, Nil)

fn canonical_form(word: String) -> String {
  word
  |> string.split("")
  |> list.sort(string.compare)
  |> string.concat
}

pub fn main() {
  let groups = read_and_group(dict.new())
  output_results(groups)
}

fn read_and_group(acc: dict.Dict(String, List(String))) -> dict.Dict(String, List(String)) {
  case read_line_external() {
    Ok(line) -> {
      let word = string.trim(line)
      let canonical = canonical_form(word)
      let updated = dict.upsert(acc, canonical, fn(opt) {
        case opt {
          Some(group) -> [word, ..group]
          None -> [word]
        }
      })
      read_and_group(updated)
    }
    Error(_) -> acc
  }
}

fn output_results(groups: dict.Dict(String, List(String))) {
  let group_list =
    groups
    |> dict.values
    |> list.map(fn(group) {
      group |> list.sort(string.compare)
    })

  let sorted_groups =
    group_list
    |> list.sort(fn(a, b) {
      case a {
        [first_a, ..] ->
          case b {
            [first_b, ..] -> string.compare(first_a, first_b)
            [] -> order.Lt
          }
        [] -> order.Gt
      }
    })

  sorted_groups
  |> list.each(fn(group) {
    group |> string.join(" ") |> io.println
  })
}
