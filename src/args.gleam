import argv

import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

import part

pub type Args {
  Args(day: Option(Int), part: Option(part.Part))
}

fn parse_day(day: String) -> Result(Int, String) {
  case int.parse(day) {
    Ok(day) -> Ok(day)
    Error(_) -> Error("provided day is not an integer")
  }
}

pub fn parse() -> Result(Args, String) {
  case argv.load().arguments {
    ["day", day, "part", part] -> {
      use day <- result.try(parse_day(day))
      use part <- result.try(part.parse(part))
      Ok(Args(day: Some(day), part: Some(part)))
    }
    ["day", day] -> {
      use day <- result.try(parse_day(day))
      Ok(Args(day: Some(day), part: None))
    }
    [] -> Ok(Args(day: None, part: None))
    other -> Error("invalid arguments: " <> string.concat(other))
  }
}
