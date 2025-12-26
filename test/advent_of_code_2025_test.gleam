import gleeunit

import advent_of_code_2025.{run_solution}
import day0
import day1

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn day0_test() {
  assert day0.run("foo") == 42
  assert run_solution(0) == Ok(42)
}

pub fn day1_example_test() {
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
  assert day1.run(input) == 3
}

pub fn day1_part1_test() {
  assert run_solution(1) == Ok(1105)
}
