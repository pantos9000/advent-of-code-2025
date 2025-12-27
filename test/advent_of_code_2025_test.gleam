import gleeunit

import advent_of_code_2025.{run_solution}
import day0
import day1
import part

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn day0_test() {
  assert day0.run_part1("foo") == 42
  assert day0.run_part2("foo") == 1337
  assert run_solution(0, part.First) == Ok(42)
  assert run_solution(0, part.Second) == Ok(1337)
}

pub fn day1_part1_example_test() {
  let input =
    "
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
  "
  assert day1.run_part1(input) == 3
}

pub fn day1_part1_test() {
  assert run_solution(1, part.First) == Ok(1105)
}

pub fn day1_part2_example_test() {
  let input =
    "
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
  "
  assert day1.run_part2(input) == 6
}

pub fn day1_part2_test() {
  assert run_solution(1, part.Second) == Ok(6599)
}
