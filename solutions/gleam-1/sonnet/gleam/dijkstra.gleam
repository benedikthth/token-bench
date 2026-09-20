import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string

@external(erlang, "io", "get_line")
fn io_get_line(prompt: String) -> Dynamic

fn read_all(acc: String) -> String {
  case decode.run(io_get_line(""), decode.string) {
    Ok(line) -> read_all(acc <> " " <> line)
    Error(_) -> acc
  }
}

fn tokenize(s: String) -> List(String) {
  s
  |> string.replace("\n", " ")
  |> string.replace("\r", " ")
  |> string.split(" ")
  |> list.filter(fn(x) { x != "" })
}

fn pop(l: List(Int)) -> #(Int, List(Int)) {
  case l {
    [x, ..rest] -> #(x, rest)
    [] -> #(0, [])
  }
}

fn take_edges(
  l: List(Int),
  count: Int,
) -> #(List(#(Int, Int, Int)), List(Int)) {
  case count {
    0 -> #([], l)
    _ -> {
      let #(u, l1) = pop(l)
      let #(v, l2) = pop(l1)
      let #(w, l3) = pop(l2)
      let #(rest_edges, final) = take_edges(l3, count - 1)
      #([#(u, v, w), ..rest_edges], final)
    }
  }
}

fn add_directed(
  adj: Dict(Int, List(#(Int, Int))),
  u: Int,
  v: Int,
  w: Int,
) -> Dict(Int, List(#(Int, Int))) {
  let existing = case dict.get(adj, u) {
    Ok(lst) -> lst
    Error(_) -> []
  }
  dict.insert(adj, u, [#(v, w), ..existing])
}

fn build_adj(edges: List(#(Int, Int, Int))) -> Dict(Int, List(#(Int, Int))) {
  list.fold(edges, dict.new(), fn(adj, e) {
    let #(u, v, w) = e
    adj
    |> add_directed(u, v, w)
    |> add_directed(v, u, w)
  })
}

fn find_min_unvisited(
  dist: Dict(Int, Int),
  visited: Set(Int),
) -> Result(#(Int, Int), Nil) {
  dist
  |> dict.to_list
  |> list.filter(fn(pair) { !set.contains(visited, pair.0) })
  |> list.fold(Error(Nil), fn(acc, pair) {
    case acc {
      Error(_) -> Ok(pair)
      Ok(#(_, best_d)) -> {
        let #(_, d) = pair
        case d < best_d {
          True -> Ok(pair)
          False -> acc
        }
      }
    }
  })
}

fn dijkstra(
  adj: Dict(Int, List(#(Int, Int))),
  dist: Dict(Int, Int),
  visited: Set(Int),
) -> Dict(Int, Int) {
  case find_min_unvisited(dist, visited) {
    Error(_) -> dist
    Ok(#(u, du)) -> {
      let visited2 = set.insert(visited, u)
      let neighbors = case dict.get(adj, u) {
        Ok(lst) -> lst
        Error(_) -> []
      }
      let dist2 =
        list.fold(neighbors, dist, fn(d, pair) {
          let #(v, w) = pair
          case set.contains(visited2, v) {
            True -> d
            False -> {
              let nd = du + w
              case dict.get(d, v) {
                Ok(existing) ->
                  case nd < existing {
                    True -> dict.insert(d, v, nd)
                    False -> d
                  }
                Error(_) -> dict.insert(d, v, nd)
              }
            }
          }
        })
      dijkstra(adj, dist2, visited2)
    }
  }
}

pub fn main() {
  let input = read_all("")
  let ints =
    tokenize(input)
    |> list.map(fn(t) { result.unwrap(int.parse(t), 0) })

  let #(_n, rest0) = pop(ints)
  let #(m, rest1) = pop(rest0)
  let #(edges, rest2) = take_edges(rest1, m)
  let #(s, rest3) = pop(rest2)
  let #(t, _rest4) = pop(rest3)

  let adj = build_adj(edges)
  let dist0 = dict.new() |> dict.insert(s, 0)
  let final_dist = dijkstra(adj, dist0, set.new())

  case dict.get(final_dist, t) {
    Ok(d) -> io.println(int.to_string(d))
    Error(_) -> io.println("-1")
  }
}
