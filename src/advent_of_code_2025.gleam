import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/result

import simplifile

import args
import day0
import day1

fn solutions() {
  dict.new()
  |> dict.insert(0, day0.run)
  |> dict.insert(1, day1.run)
}

fn last_day() -> Int {
  solutions()
  |> dict.keys()
  |> list.max(int.compare)
  |> result.lazy_unwrap(fn() { panic as "dummy day should always exist" })
}

fn load_input(day: Int) -> Result(String, String) {
  let path = "./inputs/" <> int.to_string(day) <> ".txt"
  simplifile.read(from: path)
  |> result.map_error(fn(err) {
    "failed to load input: " <> simplifile.describe_error(err)
  })
}

pub fn run_solution(day: Int) -> Result(Int, String) {
  let solutions = solutions()

  let solution_result =
    dict.get(solutions, day)
    |> result.map_error(fn(_) { "solution for day not found" })
  use solution <- result.try(solution_result)

  use input <- result.try(load_input(day))
  Ok(solution(input))
}

fn main_with_error() -> Result(Nil, String) {
  use args <- result.try(args.parse())
  let day =
    args.day
    |> option.unwrap(last_day())
  use solution <- result.try(run_solution(day))
  let solution = int.to_string(solution)
  let day = int.to_string(day)
  io.println("Solution for day " <> day <> " is: " <> solution)
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
