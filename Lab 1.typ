#let collect-steps(n, base, digits) = {
  if n == 0 {
    ((), (), ())
  } else {
    let rem = calc.rem(n, base)
    let next = calc.floor(n / base)
    let rest = collect-steps(next, base, digits)

    (
      (n,) + rest.at(0),
      (rem,) + rest.at(1),
      rest.at(2) + (digits.at(rem),),
    )
  }
}

#let base_convert_table(number, base) = {
  if base < 2 or base > 36 {
    [Base must be between 2 and 36.]
  } else {
    let digits = (
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z",
    )

    let steps = if number == 0 {
      ((0,), (0,), ("0",))
    } else {
      collect-steps(number, base, digits)
    }

    let numbers = steps.at(0)
    let remainders = steps.at(1)
    let result = steps.at(2).join()

    let rows = range(numbers.len())
      .map(i => (
        [#numbers.at(i)],
        [#base],
        [#remainders.at(i)],
      ))
      .flatten()

    grid(
      columns: (auto, auto),
      column-gutter: 12pt,

      table(
        columns: 3,
        align: center + horizon,
        inset: 6pt,
        stroke: 0.5pt,

        [*Number*], [*Base*], [*Remainder*],
        ..rows,
      ),

      // align(center + bottom)[
      //   stack( spacing: 4pt, [$uparrow$], [#result], )
      // ],
    )
  }
}
== COUNTING
Count from 1 to 20 sub(10) in the following bases:

- a) 8

$
  1_8, 2_8, 3_8, 4_8, 5_8, 6_8, 7_8, 10_8, 11_8, 12_8, 13_8, 14_8, 15_8, 16_8,
  17_8, 20_8, 21_8, 22_8, 23_8, 24_8
$

- b) 5

$
  1_5, 2_5, 3_5, 4_5, 10_5, 11_5, 12_5, 13_5, 14_5, 20_5, 21_5, 22_5, 23_5, 24_5, 30_5, 31_5, 32_5, 33_5, 34_5, 40_5
$

- c) 3

$
  1_3, 2_3, 10_3, 11_3, 12_3, 20_3, 21_3, 22_3, 100_3, 101_3, 102_3, 110_3, 111_3, 112_3, 120_3, 121_3, 122_3, 200_3, 201_3, 202_3
$

== CONVERTING INTEGERS BETWEEN BASES
Convert each of the following numbers to bases 7 and 6. First convert to
Decimal, then to the bases.

- a) Octal(67)
$
  "To Dec": 6 times 8^1 + 7 times 8^0 = 48 + 7 = 55
$
#base_convert_table(55, 6)
#base_convert_table(55, 7)
- b) Decimal(91)
#base_convert_table(91, 6)
#base_convert_table(91, 7)
- c) Hexadecimal(75)
$
  "To Decimal": 7 times 16 + 5 = #(7 * 16 + 5)
$
#base_convert_table(117, 6)
#base_convert_table(117, 7)
- d) Binary(11001)
$
  "To Decimal": #(1 * calc.pow(2, 4) + 1 * calc.pow(2, 3) + 0 + 0 + 1)
$
#base_convert_table(25, 6)
#base_convert_table(25, 7)

Convert the following numbers to their hexadecimal and binary equivalents.

- a) 24#sub[10]
#base_convert_table(24, 16)
#base_convert_table(24, 2)
- b) 6550#sub[10]
#base_convert_table(6550, 16)
#base_convert_table(6550, 2)
- c) 454#sub[10]
#base_convert_table(454, 16)
#base_convert_table(454, 2)
- d) 27#sub[8]
$"To Decimal": #(2 * calc.pow(8, 1) + 7)$
#base_convert_table(23, 16)
#base_convert_table(23, 2)
- e) 6325#sub[8]
$"To Decimal": #(6 * calc.pow(8, 3) + 3 * calc.pow(8, 2) + 2 * calc.pow(8, 1) + 5)$
#base_convert_table(3285, 16)
#base_convert_table(3285, 2)


Convert the following binary numbers to their decimal and hexadecimal
equivalents.

- a) 1101#sub[2]
$"To Decimal": #(1 * calc.pow(2, 3) + 1 * calc.pow(2, 2) + 0 + 1)$
#base_convert_table(13, 16)
- b) 1000110#sub[2]
$"To Decimal": #(1 * calc.pow(2, 6) + 0 + 0 + 0 + 1 * calc.pow(2, 2) + 1 * calc.pow(2, 1) + 0)$
#base_convert_table(70, 16)
- c) 111111#sub[2]
$"To Decimal": #(1 + 1 * calc.pow(2, 1) + 1 * calc.pow(2, 2) + 1 * calc.pow(2, 3) + 1 * calc.pow(2, 4) + 1 * calc.pow(2, 5))$
#base_convert_table(63, 16)

== CONVERTING FLOATING POINT NUMBERS BETWEEN BASES
What are the most and least significant digits in the following numbers:

- a) 441.34
- b) 0.245
- c) 234.00

Convert the following decimal numbers to their hexadecimal equivalents.

- a) 204.125#sub[10]
- b) 631.25#sub[10]

Convert the following binary numbers to their hexadecimal equivalents.

- a) 1001.1111#sub[2]
- b) 110101.011001#sub[2]
- c) 10100111011011#sub[2]

Convert the following hexadecimal numbers to their binary equivalents.

- a) E#sub[16]
- b) 1C#sub[16]
- c) A64#sub[16]
- d) 1F.C#sub[16]
- e) 239.4#sub[16]
