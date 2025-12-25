import argv

import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/string

pub type Args {
  Args(day: Option(Int))
}

pub fn parse() -> Result(Args, String) {
  case argv.load().arguments {
    ["day", day] -> {
      case int.parse(day) {
        Ok(day) -> Ok(Args(day: Some(day)))
        Error(_) -> Error("provided day is not an integer")
      }
    }
    [] -> Ok(Args(day: None))
    other -> Error("invalid arguments: " <> string.concat(other))
  }
}
