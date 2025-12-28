import gleeunit

import day3

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn joltage_test() {
  assert "987654321111111"
    |> day3.parse_battery()
    |> day3.joltage()
    == 98
  assert "811111111111119"
    |> day3.parse_battery()
    |> day3.joltage()
    == 89
  assert "234234234234278"
    |> day3.parse_battery()
    |> day3.joltage()
    == 78
  assert "818181911112111"
    |> day3.parse_battery()
    |> day3.joltage()
    == 92
}
