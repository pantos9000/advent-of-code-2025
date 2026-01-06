import gleam/int
import gleam/list
import gleam/pair
import gleam/string

pub fn run_part1(input: String) -> Int {
  let ranges = parse_ranges(input)
  let ids = parse_ids(input)

  ids
  |> list.filter(fn(id) { ranges_contain(ranges, id) })
  |> list.length()
}

type Range {
  Range(min: Int, max: Int)
}

fn range_parse(line: String) -> Range {
  let assert [min, max] =
    line
    |> string.trim()
    |> string.split("-")
    |> list.filter_map(int.parse)
  Range(min:, max:)
}

fn range_contains(range: Range, id: Int) -> Bool {
  id >= range.min && id <= range.max
}

fn ranges_contain(ranges: List(Range), id: Int) -> Bool {
  case ranges {
    [] -> False
    [range, ..rest] -> {
      case range_contains(range, id) {
        True -> True
        False -> ranges_contain(rest, id)
      }
    }
  }
}

/// note that second list starts with empty string
fn split_input(input: String) -> #(List(String), List(String)) {
  input
  |> string.split("\n")
  |> list.map(string.trim)
  |> list.split_while(fn(s) { !string.is_empty(s) })
}

fn parse_ranges(input: String) -> List(Range) {
  input
  |> split_input()
  |> pair.first()
  |> list.map(range_parse)
}

fn parse_ids(input: String) -> List(Int) {
  input
  |> split_input()
  |> pair.second()
  |> list.filter_map(int.parse)
}
