import gleam/int
import gleam/result
import gleam/string

pub fn run_part1(input: String) -> Int {
  let accu = accu_new()
  let lines = string.split(input, "\n")
  let accu = process_input(accu, lines)
  accu.count_zero
}

fn process_input(accu: Accumulator, lines: List(String)) -> Accumulator {
  case lines {
    [] -> accu
    [line, ..rest] -> {
      process_line(accu, line)
      |> process_input(rest)
    }
  }
}

fn process_line(accu: Accumulator, line: String) -> Accumulator {
  case parse_rotation_from_line(line) {
    Error(_) -> accu
    Ok(rotation) -> accu_rotate(accu, rotation)
  }
}

type Accumulator {
  Accumulator(position: Int, count_zero: Int)
}

fn accu_new() -> Accumulator {
  Accumulator(position: 50, count_zero: 0)
}

fn accu_rotate(accu: Accumulator, rotation: Rotation) -> Accumulator {
  let position =
    case rotation {
      RotLeft(amount) -> accu.position - amount
      RotRight(amount) -> accu.position + amount
    }
    % 100
  let count_zero = case position {
    0 -> accu.count_zero + 1
    _ -> accu.count_zero
  }
  Accumulator(position:, count_zero:)
}

type Rotation {
  RotLeft(amount: Int)
  RotRight(amount: Int)
}

fn parse_rotation_from_line(line: String) -> Result(Rotation, Nil) {
  let line = string.trim(line)
  use #(direction, amount) <- result.try(string.pop_grapheme(line))
  use amount <- result.try(int.parse(amount))
  case direction, amount {
    "L", amount -> Ok(RotLeft(amount))
    "R", amount -> Ok(RotRight(amount))
    _, _ -> Error(Nil)
  }
}

pub fn run_part2(input: String) -> Int {
  let accu = accu_new()
  let lines = string.split(input, "\n")
  let accu = part2_process_input(accu, lines)
  accu.count_zero
}

fn part2_process_input(accu: Accumulator, lines: List(String)) -> Accumulator {
  case lines {
    [] -> accu
    [line, ..rest] -> {
      part2_process_line(accu, line)
      |> part2_process_input(rest)
    }
  }
}

fn part2_process_line(accu: Accumulator, line: String) -> Accumulator {
  case parse_rotation_from_line(line) {
    Error(_) -> accu
    Ok(rotation) -> part2_accu_rotate(accu, rotation)
  }
}

fn part2_accu_rotate(accu: Accumulator, rotation: Rotation) -> Accumulator {
  let count_zero_passes = part2_movement_zero_passes(accu.position, rotation)
  let position = case rotation {
    RotLeft(amount) -> accu.position - amount
    RotRight(amount) -> accu.position + amount
  }
  let position = { 100 + position % 100 } % 100
  let count_zero = accu.count_zero + count_zero_passes
  Accumulator(position:, count_zero:)
}

fn part2_movement_zero_passes(position: Int, rotation: Rotation) -> Int {
  assert position >= 0
  assert position < 100
  assert case rotation {
    RotLeft(amount:) -> amount > 0
    RotRight(amount:) -> amount > 0
  }
  case rotation {
    RotLeft(amount) -> { 100 - position } % 100 + amount
    RotRight(amount) -> position + amount
  }
  / 100
}
