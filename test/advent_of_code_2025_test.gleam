import gleeunit

import advent_of_code_2025.{run_solution}
import day0
import day1
import day2
import day3
import day4
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

pub fn day2_part1_example_test() {
  let pr = day2.process_range
  assert pr("11-22") == [11, 22]
  assert pr("95-115") == [99]
  assert pr("998-1012") == [1010]
  assert pr("1188511880-1188511890") == [1_188_511_885]
  assert pr("222220-222224") == [222_222]
  assert pr("1698522-1698528") == []
  assert pr("446443-446449") == [446_446]
  assert pr("38593856-38593862") == [38_593_859]
  assert pr("824824821-824824827") == []
  assert pr("2121212118-2121212124") == []

  let input =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
    1698522-1698528,446443-446449,38593856-38593862,565653-565659,
    824824821-824824827,2121212118-2121212124"
  assert day2.run_part1(input) == 1_227_775_554
}

pub fn day2_part1_test() {
  assert run_solution(2, part.First) == Ok(17_077_011_375)
}

pub fn day2_part2_example_test() {
  let pr = day2.part2_process_range
  assert pr("11-22") == [11, 22]
  assert pr("95-115") == [99, 111]
  assert pr("998-1012") == [999, 1010]
  assert pr("1188511880-1188511890") == [1_188_511_885]
  assert pr("222220-222224") == [222_222]
  assert pr("1698522-1698528") == []
  assert pr("446443-446449") == [446_446]
  assert pr("38593856-38593862") == [38_593_859]
  assert pr("824824821-824824827") == [824_824_824]
  assert pr("2121212118-2121212124") == [2_121_212_121]

  let input =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
    1698522-1698528,446443-446449,38593856-38593862,565653-565659,
    824824821-824824827,2121212118-2121212124"
  assert day2.run_part2(input) == 4_174_379_265
}

pub fn day2_part2_test() {
  assert run_solution(2, part.Second) == Ok(36_037_497_037)
}

pub fn day3_part1_example_test() {
  let input =
    "987654321111111
     811111111111119
     234234234234278
     818181911112111"
  assert day3.run_part1(input) == 357
}

pub fn day3_part1_test() {
  assert run_solution(3, part.First) == Ok(17_613)
}

pub fn day3_part2_example_test() {
  let input =
    "987654321111111
     811111111111119
     234234234234278
     818181911112111"
  assert day3.run_part2(input) == 3_121_910_778_619
}

pub fn day4_part1_example_test() {
  let input =
    "..@@.@@@@.
     @@@.@.@.@@
     @@@@@.@.@@
     @.@@@@..@.
     @@.@@@@.@@
     .@@@@@@@.@
     .@.@.@.@@@
     @.@@@.@@@@
     .@@@@@@@@.
     @.@.@@@.@."
  assert day4.run_part1(input) == 13
}

pub fn day4_part1_test() {
  assert run_solution(4, part.First) == Ok(1474)
}
