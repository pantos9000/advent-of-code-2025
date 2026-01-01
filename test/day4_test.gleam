import gleeunit

import day4

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn map_parse_test() {
  let input =
    "
    .@
    @.
    "
  let map = day4.map_parse(input)
  assert map.width == 2
  assert map.height == 2
  assert day4.map_get(map, day4.Coord(x: 0, y: 0)) == day4.Nothing
  assert day4.map_get(map, day4.Coord(x: 1, y: 0)) == day4.Paper
  assert day4.map_get(map, day4.Coord(x: 0, y: 1)) == day4.Paper
  assert day4.map_get(map, day4.Coord(x: 1, y: 1)) == day4.Nothing
}

pub fn map_count_paper_test() {
  let input =
    "
    .@.
    @.@
    @@@
    "
  let map = day4.map_parse(input)
  assert day4.map_count_paper(map, day4.Coord(x: 0, y: 0)) == 2
  assert day4.map_count_paper(map, day4.Coord(x: 1, y: 0)) == 2
  assert day4.map_count_paper(map, day4.Coord(x: 2, y: 0)) == 2
  assert day4.map_count_paper(map, day4.Coord(x: 0, y: 1)) == 3
  assert day4.map_count_paper(map, day4.Coord(x: 1, y: 1)) == 6
  assert day4.map_count_paper(map, day4.Coord(x: 2, y: 1)) == 3
  assert day4.map_count_paper(map, day4.Coord(x: 0, y: 2)) == 2
  assert day4.map_count_paper(map, day4.Coord(x: 1, y: 2)) == 4
  assert day4.map_count_paper(map, day4.Coord(x: 2, y: 2)) == 2
}
