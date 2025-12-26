import gleeunit

import day0
import day1

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn day0_test() {
  assert day0.run("foo") == 42
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
