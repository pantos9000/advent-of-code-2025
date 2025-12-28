import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn run_part2(input: String) -> Int {
  input
  |> string.trim()
  |> string.split(",")
  |> list.flat_map(part2_process_range)
  |> int.sum()
}

pub fn part2_process_range(range: String) -> List(Int) {
  let range = range |> string.trim() |> range_from_str()
  part2_schnapps_loop1(1, range.begin, range.end, [])
  |> list.sort(int.compare)
  |> list.unique()
}

fn part2_schnapps_loop1(
  prefix: Int,
  min: Int,
  max: Int,
  acc: List(Int),
) -> List(Int) {
  case prefix {
    _ if prefix <= max && prefix < 100_000 -> {
      let acc = part2_schnapps_loop2(prefix, 2, min, max, acc)
      let prefix = prefix + 1
      part2_schnapps_loop1(prefix, min, max, acc)
    }
    _ -> acc
  }
}

/// Check if any number of repetitions of `repeated` is in `min..max`
fn part2_schnapps_loop2(
  repeated: Int,
  times: Int,
  min: Int,
  max: Int,
  acc: List(Int),
) -> List(Int) {
  let generated = digits_multiply(repeated, times)
  case generated {
    _ if generated < min ->
      part2_schnapps_loop2(repeated, times + 1, min, max, acc)
    _ if generated > max -> acc
    _ -> part2_schnapps_loop2(repeated, times + 1, min, max, [generated, ..acc])
  }
}

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

pub fn digits_multiply(x: Int, times: Int) -> Int {
  let digits = digits_num(x)
  digits_multiply_loop(x, digits, times, 0)
}

pub fn digits_multiply_loop(x: Int, digits: Int, times: Int, acc: Int) -> Int {
  case times == 0 {
    True -> acc
    False -> {
      let mult = power10(digits)
      let acc = acc * mult + x
      digits_multiply_loop(x, digits, times - 1, acc)
    }
  }
}

fn power10(to: Int) -> Int {
  int.power(10, int.to_float(to))
  |> result.unwrap(0.0)
  |> float.round()
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
  let generated = digits_multiply(digits, 2)
  case generated {
    _ if generated < min ->
      generate_schnapps_numbers_loop(digits + 1, acc, min, max)
    _ if generated > max -> acc
    _ ->
      generate_schnapps_numbers_loop(digits + 1, [generated, ..acc], min, max)
  }
}
