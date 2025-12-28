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

pub fn run_part2(input: String) -> Int {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(parse_battery)
  |> list.map(part2_joltage)
  |> int.sum()
}

pub fn part2_joltage(batteries: List(Int)) -> Int {
  let split_at = list.length(batteries) - 11
  assert split_at > 0
  let #(batteries, rest) = list.split(batteries, split_at)
  part2_joltage_loop(batteries, rest, 0)
}

fn part2_joltage_loop(batteries: List(Int), rest: List(Int), acc: Int) -> Int {
  let assert [jirst, ..batteries] = part2_split_joltage(batteries)
  let acc = 10 * acc + jirst
  case rest {
    [] -> acc
    [b, ..rest] -> {
      let batteries =
        batteries
        |> list.reverse()
        |> fn(bats) { [b, ..bats] }
        |> list.reverse()
      part2_joltage_loop(batteries, rest, acc)
    }
  }
}

fn part2_split_joltage(batteries: List(Int)) -> List(Int) {
  part2_split_joltage_loop(batteries, [])
}

fn part2_split_joltage_loop(batteries: List(Int), acc: List(Int)) -> List(Int) {
  let max_joltage = case acc {
    [] -> 0
    [j, ..] -> j
  }
  case batteries {
    [] -> acc
    [j, ..rest] if j > max_joltage -> part2_split_joltage_loop(rest, batteries)
    [_j, ..rest] -> part2_split_joltage_loop(rest, acc)
  }
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
