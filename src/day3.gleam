import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn run_part1(input: String) -> Int {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(parse_battery)
  |> list.map(joltage)
  |> int.sum()
}

pub fn parse_battery(line: String) -> List(Int) {
  line
  |> string.to_graphemes()
  |> list.filter_map(int.parse)
}

pub fn joltage(batteries: List(Int)) -> Int {
  let assert [jirst, ..batteries] = first_joltage(batteries)
  let jecond = second_joltage(batteries)
  jirst * 10 + jecond
}

fn second_joltage(batteries: List(Int)) -> Int {
  batteries |> list.max(int.compare) |> result.unwrap(0)
}

/// takes a list of batteries, returns the rest of the list, starting with
/// the first found highest joltage
fn first_joltage(batteries: List(Int)) -> List(Int) {
  first_joltage_loop(batteries, [])
}

fn first_joltage_loop(batteries: List(Int), acc: List(Int)) -> List(Int) {
  let max_joltage = case acc {
    [] -> 0
    [j, ..] -> j
  }
  case batteries {
    [] -> panic as "unreachable"
    [_j] -> acc
    [j, ..rest] if j > max_joltage -> first_joltage_loop(rest, batteries)
    [_j, ..rest] -> first_joltage_loop(rest, acc)
  }
}
