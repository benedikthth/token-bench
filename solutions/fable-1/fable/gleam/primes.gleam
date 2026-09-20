import gleam/dynamic.{type Dynamic}
import gleam/int
import gleam/io
import gleam/list
import gleam/string

@external(erlang, "io", "get_line")
fn raw_get_line(prompt: String) -> Dynamic

@external(erlang, "erlang", "is_binary")
fn is_binary(x: Dynamic) -> Bool

@external(erlang, "erlang", "is_list")
fn is_list(x: Dynamic) -> Bool

@external(erlang, "erlang", "iolist_to_binary")
fn to_binary(x: Dynamic) -> String

fn read_all() -> String {
  read_loop("")
}

fn read_loop(acc: String) -> String {
  let line = raw_get_line("")
  case is_binary(line) || is_list(line) {
    True -> read_loop(acc <> to_binary(line))
    False -> acc
  }
}

fn is_prime_naive(n: Int) -> Bool {
  n >= 2 && check_div(n, 2)
}

fn check_div(n: Int, d: Int) -> Bool {
  case d * d > n {
    True -> True
    False ->
      case n % d == 0 {
        True -> False
        False -> check_div(n, d + 1)
      }
  }
}

fn is_prime_with(n: Int, small: List(Int)) -> Bool {
  case small {
    [] -> True
    [p, ..rest] ->
      case p * p > n {
        True -> True
        False ->
          case n % p == 0 {
            True -> False
            False -> is_prime_with(n, rest)
          }
      }
  }
}

fn primes_upto(n: Int) -> List(Int) {
  case n < 2 {
    True -> []
    False -> {
      let root = int_sqrt(n)
      let small = range(2, int.max(2, root)) |> list.filter(is_prime_naive)
      range(2, n) |> list.filter(fn(x) { is_prime_with(x, small) })
    }
  }
}

fn range(from: Int, to: Int) -> List(Int) {
  range_loop(from, to, [])
}

fn range_loop(from: Int, cur: Int, acc: List(Int)) -> List(Int) {
  case cur < from {
    True -> acc
    False -> range_loop(from, cur - 1, [cur, ..acc])
  }
}

fn int_sqrt(n: Int) -> Int {
  sqrt_loop(n, 0)
}

fn sqrt_loop(n: Int, r: Int) -> Int {
  case { r + 1 } * { r + 1 } > n {
    True -> r
    False -> sqrt_loop(n, r + 1)
  }
}

pub fn main() {
  let input = read_all()
  let n = case
    input
    |> string.trim
    |> string.split(" ")
    |> list.filter(fn(s) { s != "" })
    |> list.first
  {
    Ok(tok) ->
      case int.parse(tok) {
        Ok(v) -> v
        Error(_) -> 0
      }
    Error(_) -> 0
  }
  primes_upto(n)
  |> list.map(int.to_string)
  |> string.join(" ")
  |> io.println
}
