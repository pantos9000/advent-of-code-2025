import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result

import simplifile

import args
import day0
import day1
import day2
import day3
import part

fn solutions() {
  // insert new solutions here
  dict.new()
  |> dict.insert(0, #(day0.run_part1, Some(day0.run_part2)))
  |> dict.insert(1, #(day1.run_part1, Some(day1.run_part2)))
  |> dict.insert(2, #(day2.run_part1, Some(day2.run_part2)))
  |> dict.insert(3, #(day3.run_part1, Some(day3.run_part2)))
}

fn last_day() -> Int {
  solutions()
  |> dict.keys()
  |> list.max(int.compare)
  |> result.lazy_unwrap(fn() { panic as "dummy day should always exist" })
}

fn last_part(day: Int) -> part.Part {
  case
    solutions()
    |> dict.get(day)
    |> result.lazy_unwrap(fn() { panic as "dummy day should always exist" })
  {
    #(_, None) -> part.First
    #(_, Some(_)) -> part.Second
  }
}

fn load_input(day: Int) -> Result(String, String) {
  let path = "./inputs/" <> int.to_string(day) <> ".txt"
  simplifile.read(from: path)
  |> result.map_error(fn(err) {
    "failed to load input: " <> simplifile.describe_error(err)
  })
}

pub fn run_solution(day: Int, part: part.Part) -> Result(Int, String) {
  let solutions = solutions()

  let solution_result =
    dict.get(solutions, day)
    |> result.map_error(fn(_) { "solution for day not found" })
  use solution <- result.try(solution_result)
  let solution = case part {
    part.First -> Ok(solution.0)
    part.Second ->
      case solution.1 {
        None -> Error("day part 2 not found")
        Some(part2) -> Ok(part2)
      }
  }
  use solution <- result.try(solution)

  use input <- result.try(load_input(day))
  Ok(solution(input))
}

fn main_with_error() -> Result(Nil, String) {
  use args <- result.try(args.parse())
  let day =
    args.day
    |> option.unwrap(last_day())
  let part =
    args.part
    |> option.unwrap(last_part(day))
  use solution <- result.try(run_solution(day, part))
  let solution = int.to_string(solution)
  let day = int.to_string(day)
  let part = part.to_string(part)
  io.println("Solution for day " <> day <> " " <> part <> " is: " <> solution)
  Ok(Nil)
}

pub fn main() {
  case main_with_error() {
    Ok(Nil) -> Nil
    Error(err) -> {
      io.println_error("An error occurred: " <> err)
    }
  }
}
