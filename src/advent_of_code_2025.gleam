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

fn last_day(solutions) -> Int {
  dict.keys(solutions)
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

fn run() -> Result(Nil, String) {
  let solutions = solutions()
  let default_day = last_day(solutions)
  use args <- result.try(args.parse())

  let day =
    args.day
    |> option.unwrap(default_day)

  let solution_result =
    dict.get(solutions, day)
    |> result.map_error(fn(_) { "day not found" })
  use solution <- result.try(solution_result)

  use input <- result.try(load_input(day))
  let output =
    solution(input)
    |> int.to_string()
  let day = int.to_string(day)

  io.println("Solution for day " <> day <> " is: " <> output)

  Ok(Nil)
}

pub fn main() {
  case run() {
    Ok(Nil) -> Nil
    Error(err) -> {
      io.println_error("An error occurred: " <> err)
    }
  }
}
