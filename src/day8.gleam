import gleam/int
import gleam/list
import gleam/set.{type Set}
import gleam/string

type Link =
  #(Jox, Jox)

type Circuit =
  Set(Jox)

pub fn run_part1(input: String) -> Int {
  let joxes: List(Jox) =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.map(jox_parse)

  // wtf why is this not depending on input. oh well...
  let max_links = case list.length(joxes) {
    20 -> 10
    1000 -> 1000
    _ -> panic as "unknown number of max steps, pls check input"
  }

  let links =
    min_dist_list(joxes)
    |> list.take(max_links)

  let circuit_sizes =
    circuits_gather(links)
    |> list.map(set.size)

  circuit_sizes
  |> list.sort(int.compare)
  |> list.reverse()
  |> list.take(3)
  |> list.fold(1, fn(x, y) { x * y })
}

pub fn run_part2(input: String) -> Int {
  let joxes: List(Jox) =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.map(jox_parse)

  let jox_count = list.length(joxes)
  let links = min_dist_list(joxes)

  let final_link = part2_loop(links, jox_count, set.new())
  { final_link.0 }.x * { final_link.1 }.x
}

fn part2_loop(links: List(Link), jox_count: Int, acc: Circuit) -> Link {
  case links {
    [] -> panic as "reached end of all links"
    [link, ..rest] -> {
      let acc = acc |> circuit_insert_link(link)
      case set.size(acc) == jox_count {
        True -> link
        False -> part2_loop(rest, jox_count, acc)
      }
    }
  }
}

fn min_dist_list(joxes: List(Jox)) -> List(Link) {
  joxes
  |> list.combination_pairs()
  |> list.map(fn(link) { #(link, jox_sqdist(link.0, link.1)) })
  |> list.sort(fn(elem1, elem2) { int.compare(elem1.1, elem2.1) })
  |> list.map(fn(elem) { elem.0 })
}

fn circuits_gather(links: List(Link)) -> List(Circuit) {
  circuits_gather_loop(links, [])
}

fn circuits_gather_loop(links: List(Link), acc: List(Circuit)) -> List(Circuit) {
  case links {
    [] -> acc
    [link, ..rest] -> {
      let circuit =
        set.new()
        |> circuit_insert_link(link)
        |> circuit_extend_from_links(rest)
      let acc = [circuit, ..acc]
      let links = rest |> links_remove_if_in_circuit(circuit)
      circuits_gather_loop(links, acc)
    }
  }
}

fn links_remove_if_in_circuit(links: List(Link), circuit: Circuit) -> List(Link) {
  links_remove_if_in_circuit_loop(links, circuit, [])
}

fn links_remove_if_in_circuit_loop(
  links: List(Link),
  circuit: Circuit,
  acc: List(Link),
) -> List(Link) {
  case links {
    [] -> acc
    [link, ..rest] -> {
      case set.contains(circuit, link.0) && set.contains(circuit, link.1) {
        True -> links_remove_if_in_circuit_loop(rest, circuit, acc)
        False -> links_remove_if_in_circuit_loop(rest, circuit, [link, ..acc])
      }
    }
  }
}

fn circuit_extend_from_links(circuit: Circuit, links: List(Link)) -> Circuit {
  let new_circuit = circuit_extend_from_links_inner(circuit, links)
  case set.size(new_circuit) == set.size(circuit) {
    True -> new_circuit
    False -> circuit_extend_from_links(new_circuit, links)
  }
}

fn circuit_extend_from_links_inner(
  circuit: Circuit,
  links: List(Link),
) -> Circuit {
  case links {
    [] -> circuit
    [link, ..rest] -> {
      let circuit = case circuit_contains_link_part(circuit, link) {
        True -> circuit_insert_link(circuit, link)
        False -> circuit
      }
      circuit_extend_from_links_inner(circuit, rest)
    }
  }
}

fn circuit_insert_link(circuit: Circuit, link: Link) -> Circuit {
  circuit |> set.insert(link.0) |> set.insert(link.1)
}

fn circuit_contains_link_part(circuit: Circuit, link: Link) -> Bool {
  set.contains(circuit, link.0) || set.contains(circuit, link.1)
}

type Jox {
  Jox(x: Int, y: Int, z: Int)
}

fn jox_parse(line: String) -> Jox {
  let assert [x, y, z] =
    line
    |> string.trim()
    |> string.split(",")
    |> list.filter_map(int.parse)
  Jox(x:, y:, z:)
}

fn jox_sqdist(jox: Jox, other: Jox) -> Int {
  let dx = jox_sqdist_1d(jox.x, other.x)
  let dy = jox_sqdist_1d(jox.y, other.y)
  let dz = jox_sqdist_1d(jox.z, other.z)
  dx + dy + dz
}

fn jox_sqdist_1d(one: Int, other: Int) -> Int {
  let d = int.absolute_value(one - other)
  d * d
}
