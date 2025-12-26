import gleeunit

import day0

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn day0_test() {
  assert day0.run("foo") == 42
}
