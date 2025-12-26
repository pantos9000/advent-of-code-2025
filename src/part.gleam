pub type Part {
  First
  Second
}

pub fn parse(part: String) -> Result(Part, String) {
  case part {
    "1" -> Ok(First)
    "2" -> Ok(Second)
    other -> Error("invalid part '" <> other <> "', must be 1 or 2")
  }
}

pub fn to_string(part: Part) -> String {
  case part {
    First -> "part 1"
    Second -> "part 2"
  }
}
