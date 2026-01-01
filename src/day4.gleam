import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleam/string

pub fn run_part1(input: String) -> Int {
  let map = map_parse(input)
  let coords = map_coords(map)
  part1_loop(map, coords, 0)
}

fn part1_loop(map: Map, coords: List(Coord), acc: Int) -> Int {
  case coords {
    [] -> acc
    [coord, ..rest] -> {
      case map_coord_is_stapleable(map, coord) {
        True -> part1_loop(map, rest, acc + 1)
        False -> part1_loop(map, rest, acc)
      }
    }
  }
}

pub type Content {
  Paper
  Nothing
}

fn content_parse(c: String) -> Content {
  case c {
    "@" -> Paper
    _ -> Nothing
  }
}

// type Spot {
//   Spot(
//     self: Content,
//     up: Content,
//     down: Content,
//     left: Content,
//     right: Content,
//     up_left: Content,
//     up_right: Content,
//     low_left: Content,
//     low_right: Content,
//   )
// }

pub type Map {
  Map(map: Dict(Coord, Content), width: Int, height: Int)
}

pub type Coord {
  Coord(x: Int, y: Int)
}

fn map_parse_width(input: String) -> Int {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.first()
  |> result.unwrap("")
  |> string.trim()
  |> string.length()
}

fn map_parse_height(input: String) -> Int {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.length()
}

pub fn map_parse(input: String) -> Map {
  let width = map_parse_width(input)
  let height = map_parse_height(input)

  let lines =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.map(string.trim)
    |> list.map(string.to_graphemes)

  let map = map_parse_loop(0, lines, dict.new())
  Map(map, width, height)
}

fn map_parse_loop(
  y: Int,
  lines: List(List(String)),
  acc: Dict(Coord, Content),
) -> Dict(Coord, Content) {
  case lines {
    [] -> acc
    [line, ..rest] -> {
      let acc = map_parse_line(y, line, acc)
      map_parse_loop(y + 1, rest, acc)
    }
  }
}

fn map_parse_line(
  y: Int,
  line: List(String),
  acc: Dict(Coord, Content),
) -> Dict(Coord, Content) {
  map_parse_line_loop(0, y, line, acc)
}

fn map_parse_line_loop(
  x: Int,
  y: Int,
  line: List(String),
  acc: Dict(Coord, Content),
) {
  case line {
    [] -> acc
    [c, ..rest] -> {
      let coord = Coord(x, y)
      let content = content_parse(c)
      let acc = dict.insert(acc, coord, content)
      map_parse_line_loop(x + 1, y, rest, acc)
    }
  }
}

fn map_coords(map: Map) -> List(Coord) {
  dict.keys(map.map)
}

pub fn map_get(map: Map, coord: Coord) -> Content {
  dict.get(map.map, coord)
  |> result.unwrap(Nothing)
}

pub fn map_count_paper(map: Map, coord: Coord) -> Int {
  let Coord(x, y) = coord
  let ul = Coord(x: x - 1, y: y - 1)
  let uu = Coord(x: x + 0, y: y - 1)
  let ur = Coord(x: x + 1, y: y - 1)
  let ll = Coord(x: x - 1, y: y + 0)
  let rr = Coord(x: x + 1, y: y + 0)
  let dl = Coord(x: x - 1, y: y + 1)
  let dd = Coord(x: x + 0, y: y + 1)
  let dr = Coord(x: x + 1, y: y + 1)

  let paper_count = 0
  let paper_count = map_count_paper_loop(map, ul, paper_count)
  let paper_count = map_count_paper_loop(map, uu, paper_count)
  let paper_count = map_count_paper_loop(map, ur, paper_count)
  let paper_count = map_count_paper_loop(map, ll, paper_count)
  let paper_count = map_count_paper_loop(map, rr, paper_count)
  let paper_count = map_count_paper_loop(map, dl, paper_count)
  let paper_count = map_count_paper_loop(map, dd, paper_count)
  let paper_count = map_count_paper_loop(map, dr, paper_count)
  paper_count
}

fn map_count_paper_loop(map: Map, coord: Coord, acc: Int) -> Int {
  case map_get(map, coord) {
    Nothing -> acc
    Paper -> acc + 1
  }
}

fn map_coord_is_stapleable(map: Map, coord: Coord) -> Bool {
  map_get(map, coord) == Paper && map_count_paper(map, coord) < 4
}
