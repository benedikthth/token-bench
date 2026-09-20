import gleam/io
import gleam/int
import gleam/list
import gleam/string

@external(erlang, "io", "get_line")
fn erl_get_line(prompt: String) -> String

pub fn main() {
  let line = erl_get_line("")
  let trimmed = string.trim(line)
  case int.parse(trimmed) {
    Ok(n) -> {
      let primes = primes_up_to(n)
      io.println(string.join(list.map(primes, int.to_string), " "))
    }
    Error(_) -> io.println("")
  }
}

fn primes_up_to(n: Int) -> List(Int) {
  collect(2, n, [])
  |> list.reverse
}

fn collect(current: Int, n: Int, acc: List(Int)) -> List(Int) {
  case current > n {
    True -> acc
    False -> {
      let new_acc = case is_prime(current, 2) {
        True -> [current, ..acc]
        False -> acc
      }
      collect(current + 1, n, new_acc)
    }
  }
}

fn is_prime(n: Int, divisor: Int) -> Bool {
  case divisor * divisor > n {
    True -> True
    False ->
      case n % divisor == 0 {
        True -> False
        False -> is_prime(n, divisor + 1)
      }
  }
}
