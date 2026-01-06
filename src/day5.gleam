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

pub fn run_part2(input: String) -> Int {
  parse_ranges(input)
  |> part2_merge_ranges()
  |> list.map(range_size)
  |> int.sum()
}

fn part2_merge_ranges(ranges: List(Range)) -> List(Range) {
  ranges
  |> list.sort(fn(r1, r2) { int.compare(r1.min, r2.min) })
  |> part2_merge_ranges_loop([])
}

fn part2_merge_ranges_loop(ranges: List(Range), acc: List(Range)) -> List(Range) {
  case ranges {
    [] -> acc
    [range] -> [range, ..acc]
    [range1, range2, ..rest] -> {
      case range1.max < range2.min - 1 {
        True -> {
          let acc = [range1, ..acc]
          let rest = [range2, ..rest]
          part2_merge_ranges_loop(rest, acc)
        }
        False -> {
          // invariant: range1.min <= range2.min because of sort
          let min = range1.min
          let max = int.max(range1.max, range2.max)
          let new_range = Range(min:, max:)
          let rest = [new_range, ..rest]
          part2_merge_ranges_loop(rest, acc)
        }
      }
    }
  }
}

type Range {
  Range(min: Int, max: Int)
}

fn range_size(range: Range) -> Int {
  range.max - range.min + 1
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
