import gleam/io
import gleam/int
import gleam/list
import gleam/string

pub fn main() {
  let line = read_line("")
  case int.parse(string.trim(line)) {
    Error(_) -> io.println("")
    Ok(n) -> {
      let primes = find_primes(n)
      let output = list.map(primes, int.to_string)
      io.println(string.join(output, " "))
    }
  }
}

@external(erlang, "io", "get_line")
fn read_line(prompt: String) -> String

fn find_primes(n: Int) -> List(Int) {
  case n < 2 {
    True -> []
    False -> {
      let candidates = make_range(2, n + 1)
      sieve(candidates)
    }
  }
}

fn make_range(start: Int, end: Int) -> List(Int) {
  case start >= end {
    True -> []
    False -> [start, ..make_range(start + 1, end)]
  }
}

fn sieve(candidates: List(Int)) -> List(Int) {
  case candidates {
    [] -> []
    [prime, ..rest] -> {
      let remaining = list.filter(rest, fn(x) { x % prime != 0 })
      [prime, ..sieve(remaining)]
    }
  }
}
