import gleam/io
import gleam/string
import gleam/list
import gleam/dict
import gleam/regex
import gleam/int
import gleam/order
import gleam/erlang/process

pub fn main() {
  let input = read_all_input("")
  let words = extract_words(input)
  let word_counts = count_words(words, dict.new())
  let sorted = sort_word_counts(word_counts)
  print_results(sorted)
}

fn read_all_input(acc: String) -> String {
  case io.read_line("") {
    Ok(line) -> {
      read_all_input(acc <> line <> "\n")
    }
    Error(_) -> acc
  }
}

fn extract_words(text: String) -> List(String) {
  let assert Ok(word_pattern) = regex.from_string("[a-zA-Z]+")
  regex.scan(word_pattern, text)
  |> list.map(fn(match) {
    match.content
    |> string.lowercase()
  })
}

fn count_words(
  words: List(String),
  counts: dict.Dict(String, Int),
) -> dict.Dict(String, Int) {
  case words {
    [] -> counts
    [word, ..rest] -> {
      let new_count = case dict.get(counts, word) {
        Ok(n) -> n + 1
        Error(_) -> 1
      }
      count_words(rest, dict.insert(counts, word, new_count))
    }
  }
}

fn sort_word_counts(
  counts: dict.Dict(String, Int),
) -> List(#(String, Int)) {
  counts
  |> dict.to_list()
  |> list.sort(fn(a, b) {
    case int.compare(a.1, b.1) {
      order.Gt -> order.Lt
      order.Lt -> order.Gt
      order.Eq -> string.compare(a.0, b.0)
    }
  })
}

fn print_results(results: List(#(String, Int))) -> Nil {
  list.each(results, fn(item) {
    let #(word, count) = item
    io.println(word <> " " <> int.to_string(count))
  })
}
