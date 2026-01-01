import gleam/list
import gleam/set.{type Set}
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

fn contains_paper(c: String) -> Bool {
  case c {
    "@" -> True
    _ -> False
  }
}

pub type Map =
  Set(Coord)

pub type Coord {
  Coord(x: Int, y: Int)
}

pub fn map_parse(input: String) -> Map {
  let lines =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.map(string.trim)
    |> list.map(string.to_graphemes)

  map_parse_loop(0, lines, set.new())
}

fn map_parse_loop(y: Int, lines: List(List(String)), acc: Map) -> Map {
  case lines {
    [] -> acc
    [line, ..rest] -> {
      let acc = map_parse_line(y, line, acc)
      map_parse_loop(y + 1, rest, acc)
    }
  }
}

fn map_parse_line(y: Int, line: List(String), acc: Map) -> Map {
  map_parse_line_loop(0, y, line, acc)
}

fn map_parse_line_loop(x: Int, y: Int, line: List(String), acc: Map) {
  case line {
    [] -> acc
    [c, ..rest] -> {
      let coord = Coord(x, y)
      let acc = case contains_paper(c) {
        False -> acc
        True -> set.insert(acc, coord)
      }
      map_parse_line_loop(x + 1, y, rest, acc)
    }
  }
}

fn map_coords(map: Map) -> List(Coord) {
  set.to_list(map)
}

pub fn map_is_paper(map: Map, coord: Coord) -> Bool {
  set.contains(map, coord)
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
  case map_is_paper(map, coord) {
    False -> acc
    True -> acc + 1
  }
}

fn map_coord_is_stapleable(map: Map, coord: Coord) -> Bool {
  map_is_paper(map, coord) && map_count_paper(map, coord) < 4
}
