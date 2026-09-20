import gleam/io
import gleam/int
import gleam/string

pub fn main() {
  io.println(to_roman(1))
  io.println(to_roman(4))
  io.println(to_roman(9))
  io.println(to_roman(58))
  io.println(to_roman(1994))
  io.println(to_roman(3999))
}

fn to_roman(num: Int) -> String {
  let mapping = [
    #(1000, "M"),
    #(900, "CM"),
    #(500, "D"),
    #(400, "CD"),
    #(100, "C"),
    #(90, "XC"),
    #(50, "L"),
    #(40, "XL"),
    #(10, "X"),
    #(9, "IX"),
    #(5, "V"),
    #(4, "IV"),
    #(1, "I"),
  ]
  convert_roman(num, mapping, "")
}

fn convert_roman(num: Int, mapping: List(#(Int, String)), acc: String) -> String {
  case mapping {
    [] -> acc
    [#(value, symbol), ..rest] -> {
      let count = num / value
      let new_num = num % value
      let new_acc = acc <> repeat_string(symbol, count)
      convert_roman(new_num, rest, new_acc)
    }
  }
}

fn repeat_string(s: String, count: Int) -> String {
  case count {
    0 -> ""
    n -> s <> repeat_string(s, n - 1)
  }
}

fn to_roman(num: Int) -> String {
  let mapping = [
    #(1000, "M"),
    #(900, "CM"),
    #(500, "D"),
    #(400, "CD"),
    #(100, "C"),
    #(90, "XC"),
    #(50, "L"),
    #(40, "XL"),
    #(10, "X"),
    #(9, "IX"),
    #(5, "V"),
    #(4, "IV"),
    #(1, "I"),
  ]
  convert_roman(num, mapping, "")
}

fn convert_roman(num: Int, mapping: List(#(Int, String)), acc: String) -> String {
  case mapping {
    [] -> acc
    [#(value, symbol), ..rest] -> {
      let count = num / value
      let new_num = num % value
      let new_acc = acc <> repeat_string(symbol, count)
      convert_roman(new_num, rest, new_acc)
    }
  }
}

fn repeat_string(s: String, count: Int) -> String {
  case count {
    0 -> ""
    n -> s <> repeat_string(s, n - 1)
  }
}
