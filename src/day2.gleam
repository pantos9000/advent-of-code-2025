import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn run_part1(input: String) -> Int {
  input
  |> string.trim()
  |> string.split(",")
  |> list.flat_map(process_range)
  |> int.sum()
}

pub fn process_range(range: String) -> List(Int) {
  let range = range |> string.trim() |> range_from_str()
  let gen_digits = digits_first_half(range.begin)
  generate_schnapps_numbers(gen_digits, range.begin, range.end)
}

pub type Range {
  Range(begin: Int, end: Int)
}

fn range_from_str(s: String) -> Range {
  let assert Ok(#(begin, end)) = string.split_once(s, "-")
  let assert Ok(begin) = int.parse(begin)
  let assert Ok(end) = int.parse(end)
  Range(begin:, end:)
}

pub fn digits_first_half(x: Int) -> Int {
  assert x != 0
  let digits = digits_num(x)
  let digits =
    case int.is_even(digits) {
      True -> digits
      False -> digits + 1
    }
    / 2
  digits_reduce(x, digits)
}

pub fn digits_num(x: Int) -> Int {
  assert x >= 0
  digits_num_loop(x, 0)
}

fn digits_num_loop(x: Int, acc: Int) -> Int {
  case x < 10 {
    True -> acc + 1
    False -> digits_num_loop(x / 10, acc + 1)
  }
}

pub fn digits_reduce(x: Int, digits: Int) -> Int {
  assert digits >= 0
  assert x >= 0
  case digits == 0 {
    True -> x
    False -> digits_reduce(x / 10, digits - 1)
  }
}

pub fn digits_double(x: Int) -> Int {
  let digits = digits_num(x)
  let mult =
    int.power(10, int.to_float(digits))
    |> result.unwrap(0.0)
    |> float.round()
  x * mult + x
}

pub fn generate_schnapps_numbers(digits: Int, min: Int, max: Int) -> List(Int) {
  generate_schnapps_numbers_loop(digits, [], min, max)
  |> list.reverse()
}

fn generate_schnapps_numbers_loop(
  digits: Int,
  acc: List(Int),
  min: Int,
  max: Int,
) -> List(Int) {
  let generated = digits_double(digits)
  case generated {
    _ if generated < min ->
      generate_schnapps_numbers_loop(digits + 1, acc, min, max)
    _ if generated > max -> acc
    _ ->
      generate_schnapps_numbers_loop(digits + 1, [generated, ..acc], min, max)
  }
}
