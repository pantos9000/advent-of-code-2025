import gleeunit

import day2

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn digits_double_test() {
  let dd = day2.digits_double
  assert dd(1) == 11
  assert dd(12) == 1212
  assert dd(234) == 234_234
}

pub fn digits_reduce_test() {
  let dfh = day2.digits_first_half
  assert dfh(11) == 1
  assert dfh(111) == 1
  assert dfh(1111) == 11
  assert dfh(1234) == 12
  assert dfh(12_345) == 12
}

pub fn digits_num_test() {
  let dn = day2.digits_num
  assert dn(123) == 3
  assert dn(1) == 1
}

pub fn schnapps_test() {
  let gsn = day2.generate_schnapps_numbers
  assert gsn(12, 0, 1200) == []
  assert gsn(12, 0, 1300) == [1212]
  assert gsn(12, 0, 1400) == [1212, 1313]
  assert gsn(12, 0, 1500) == [1212, 1313, 1414]
  assert gsn(12, 0, 1212) == [1212]
  assert gsn(12, 0, 1211) == []
  assert gsn(12, 1300, 1400) == [1313]
}
