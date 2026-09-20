import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/string

// ---------- stdin via Erlang externals (no extra packages needed) ----------

type Raw

@external(erlang, "io", "get_line")
fn raw_get_line(prompt: String) -> Raw

@external(erlang, "erlang", "is_atom")
fn is_atom(x: Raw) -> Bool

@external(erlang, "unicode", "characters_to_binary")
fn raw_to_string(x: Raw) -> String

fn read_all(acc: List(String)) -> String {
  let line = raw_get_line("")
  case is_atom(line) {
    // eof
    True -> acc |> list.reverse |> string.concat
    False -> read_all([raw_to_string(line), ..acc])
  }
}

fn tokenize(input: String) -> List(Int) {
  input
  |> string.replace("\r", " ")
  |> string.replace("\n", " ")
  |> string.replace("\t", " ")
  |> string.split(" ")
  |> list.filter_map(fn(tok) {
    case tok {
      "" -> Error(Nil)
      _ -> int.parse(tok)
    }
  })
}

// ---------- pairing heap keyed on distance ----------

type Heap {
  Empty
  Node(d: Int, v: Int, children: List(Heap))
}

fn merge(a: Heap, b: Heap) -> Heap {
  case a, b {
    Empty, _ -> b
    _, Empty -> a
    Node(d1, v1, c1), Node(d2, v2, c2) ->
      case d1 <= d2 {
        True -> Node(d1, v1, [b, ..c1])
        False -> Node(d2, v2, [a, ..c2])
      }
  }
}

fn insert(h: Heap, d: Int, v: Int) -> Heap {
  merge(h, Node(d, v, []))
}

fn merge_pairs(l: List(Heap)) -> Heap {
  case l {
    [] -> Empty
    [x] -> x
    [a, b, ..rest] -> merge(merge(a, b), merge_pairs(rest))
  }
}

fn pop(h: Heap) -> Result(#(Int, Int, Heap), Nil) {
  case h {
    Empty -> Error(Nil)
    Node(d, v, children) -> Ok(#(d, v, merge_pairs(children)))
  }
}

// ---------- graph ----------

type Graph =
  Dict(Int, List(#(Int, Int)))

fn add_edge(g: Graph, u: Int, v: Int, w: Int) -> Graph {
  let existing = case dict.get(g, u) {
    Ok(l) -> l
    Error(_) -> []
  }
  dict.insert(g, u, [#(v, w), ..existing])
}

fn read_edges(m: Int, tokens: List(Int), g: Graph) -> #(Graph, List(Int)) {
  case m <= 0 {
    True -> #(g, tokens)
    False ->
      case tokens {
        [u, v, w, ..rest] ->
          read_edges(m - 1, rest, g |> add_edge(u, v, w) |> add_edge(v, u, w))
        _ -> #(g, tokens)
      }
  }
}

fn dijkstra(g: Graph, s: Int, t: Int) -> Int {
  run(g, t, insert(Empty, 0, s), dict.new())
}

fn run(g: Graph, t: Int, heap: Heap, settled: Dict(Int, Int)) -> Int {
  case pop(heap) {
    Error(Nil) -> -1
    Ok(#(d, v, rest)) ->
      case v == t {
        True -> d
        False ->
          case dict.has_key(settled, v) {
            True -> run(g, t, rest, settled)
            False -> {
              let settled2 = dict.insert(settled, v, d)
              let neighbors = case dict.get(g, v) {
                Ok(l) -> l
                Error(_) -> []
              }
              let heap2 =
                list.fold(neighbors, rest, fn(h, e) {
                  let #(u, w) = e
                  case dict.has_key(settled2, u) {
                    True -> h
                    False -> insert(h, d + w, u)
                  }
                })
              run(g, t, heap2, settled2)
            }
          }
      }
  }
}

pub fn main() {
  let tokens = read_all([]) |> tokenize
  case tokens {
    [_n, m, ..rest] -> {
      let #(g, rest2) = read_edges(m, rest, dict.new())
      case rest2 {
        [s, t, ..] -> io.println(int.to_string(dijkstra(g, s, t)))
        _ -> io.println("-1")
      }
    }
    _ -> io.println("-1")
  }
}
