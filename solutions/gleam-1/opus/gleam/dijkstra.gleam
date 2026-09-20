import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/string

type Raw

@external(erlang, "io", "get_line")
fn get_line(prompt: String) -> Raw

@external(erlang, "unicode", "characters_to_binary")
fn to_string(x: Raw) -> String

@external(erlang, "erlang", "is_atom")
fn is_atom(x: Raw) -> Bool

fn read_all(acc: List(String)) -> String {
  let line = get_line("")
  case is_atom(line) {
    True -> string.concat(list.reverse(acc))
    False -> read_all([to_string(line), ..acc])
  }
}

type Heap {
  Empty
  Node(key: Int, val: Int, children: List(Heap))
}

fn meld(a: Heap, b: Heap) -> Heap {
  case a, b {
    Empty, _ -> b
    _, Empty -> a
    Node(ka, va, ca), Node(kb, vb, cb) ->
      case ka <= kb {
        True -> Node(ka, va, [b, ..ca])
        False -> Node(kb, vb, [a, ..cb])
      }
  }
}

fn merge_pairs(hs: List(Heap)) -> Heap {
  case hs {
    [] -> Empty
    [h] -> h
    [a, b, ..rest] -> meld(meld(a, b), merge_pairs(rest))
  }
}

fn tokens(s: String) -> List(Int) {
  s
  |> string.replace("\r", " ")
  |> string.replace("\n", " ")
  |> string.replace("\t", " ")
  |> string.split(" ")
  |> list.filter_map(fn(x) { int.parse(x) })
}

fn read_edges(
  ts: List(Int),
  m: Int,
  adj: Dict(Int, List(#(Int, Int))),
) -> #(List(Int), Dict(Int, List(#(Int, Int)))) {
  case m, ts {
    0, _ -> #(ts, adj)
    _, [u, v, w, ..rest] -> {
      let adj = add(add(adj, u, v, w), v, u, w)
      read_edges(rest, m - 1, adj)
    }
    _, _ -> #(ts, adj)
  }
}

fn add(adj, u, v, w) {
  let cur = case dict.get(adj, u) {
    Ok(l) -> l
    Error(_) -> []
  }
  dict.insert(adj, u, [#(v, w), ..cur])
}

fn dijkstra(
  heap: Heap,
  dist: Dict(Int, Int),
  adj: Dict(Int, List(#(Int, Int))),
  t: Int,
) -> Int {
  case heap {
    Empty -> -1
    Node(d, u, children) -> {
      let rest = merge_pairs(children)
      case dict.get(dist, u) {
        Ok(best) if best < d -> dijkstra(rest, dist, adj, t)
        _ ->
          case u == t {
            True -> d
            False -> {
              let edges = case dict.get(adj, u) {
                Ok(l) -> l
                Error(_) -> []
              }
              let #(h, ds) =
                list.fold(edges, #(rest, dist), fn(acc, e) {
                  let #(h, ds) = acc
                  let #(v, w) = e
                  let nd = d + w
                  case dict.get(ds, v) {
                    Ok(old) if old <= nd -> acc
                    _ -> #(meld(h, Node(nd, v, [])), dict.insert(ds, v, nd))
                  }
                })
              dijkstra(h, ds, adj, t)
            }
          }
      }
    }
  }
}

pub fn main() {
  let input = read_all([])
  case tokens(input) {
    [_n, m, ..rest] -> {
      let #(rest, adj) = read_edges(rest, m, dict.new())
      case rest {
        [s, t, ..] ->
          case s == t {
            True -> io.println("0")
            False ->
              io.println(
                int.to_string(dijkstra(
                  Node(0, s, []),
                  dict.from_list([#(s, 0)]),
                  adj,
                  t,
                )),
              )
          }
        _ -> io.println("-1")
      }
    }
    _ -> io.println("-1")
  }
}
