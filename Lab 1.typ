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

- a) $441.34$
  - *Most Significant Digit (MSD)*: The leftmost non-zero digit is $4$ (the first $4$ in $441$).
  - *Least Significant Digit (LSD)*: The rightmost digit is $4$ (in the fractional part $0.34$).

- b) $0.245$
  - *Most Significant Digit (MSD)*: The leftmost digit is $0$ (the integer part).
  - *Least Significant Digit (LSD)*: The rightmost digit is $5$.

- c) $234.00$
  - *Most Significant Digit (MSD)*: The leftmost digit is $2$.
  - *Least Significant Digit (LSD)*: The rightmost digit is $0$ (the last $0$ in $0.00$).

---

Convert the following decimal numbers to their hexadecimal equivalents.

- a) $204.125#sub[10]$

*Integer part* ($204$) using repeated division by $16$:

#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: center + horizon,
    inset: 6pt,
    stroke: 0.5pt,
    [*Division*], [*Quotient*], [*Remainder (hex)*],
    [$204 div 16$], [$12$], [$12 = "C"$],
    [$12 div 16$], [$0$], [$12 = "C"$],
  )
]

Reading the remainders *bottom-up*: $204 = "CC"_(16)$.

*Fractional part* ($0.125$) using repeated multiplication by $16$:

#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: center + horizon,
    inset: 6pt,
    stroke: 0.5pt,
    [*Multiplication*], [*Product*], [*Integer (hex)*],
    [$0.125 times 16$], [$2.0$], [$2$],
  )
]

Since the product is exactly $2.0$, the process terminates. Thus $0.125_(10) = .2_(16)$.

#v(6pt)
#text(weight: "bold")[Result:] $"CC".2_(16)$

- b) $631.25#sub[10]$

*Integer part* ($631$) using repeated division by $16$:

#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: center + horizon,
    inset: 6pt,
    stroke: 0.5pt,
    [*Division*], [*Quotient*], [*Remainder (hex)*],
    [$631 div 16$], [$39$], [$7$],
    [$39 div 16$], [$2$], [$7$],
    [$2 div 16$], [$0$], [$2$],
  )
]

Reading the remainders *bottom-up*: $631 = 277_(16)$.

*Fractional part* ($0.25$) using repeated multiplication by $16$:

#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: center + horizon,
    inset: 6pt,
    stroke: 0.5pt,
    [*Multiplication*], [*Product*], [*Integer (hex)*],
    [$0.25 times 16$], [$4.0$], [$4$],
  )
]

Since the product is exactly $4.0$, the process terminates. Thus $0.25_(10) = .4_(16)$.

#v(6pt)
#text(weight: "bold")[Result:] $277.4_(16)$

---

Convert the following binary numbers to their hexadecimal equivalents.

- a) $1001.1111#sub[2]$

Group the integer part into 4-bit groups from the *right*, and the fractional part into 4-bit groups from the *left*:

#v(4pt)
#align(center)[
  $1001_2 = 9_(16)$

  $.1111_2 = "F"_(16)$
]

#text(weight: "bold")[Result:] $9."F"_(16)$

- b) $110101.011001#sub[2]$

Group the integer part into 4-bit groups from the *right* (pad with leading zeros if needed):

#v(4pt)
#align(center)[
  $110101_2 = 0011\,0101_2$

  $0011_2 = 3_(16)$, $0101_2 = 5_(16)$
]

Group the fractional part into 4-bit groups from the *left* (pad with trailing zeros if needed):

#v(4pt)
#align(center)[
  $.011001_2 = .0110\,0100_2$

  $0110_2 = 6_(16)$, $0100_2 = 4_(16)$
]

#text(weight: "bold")[Result:] $35.64_(16)$

- c) $10100111011011#sub[2]$

Group the integer part into 4-bit groups from the *right* (pad with leading zeros if needed):

#v(4pt)
#align(center)[
  $10100111011011_2 = 0010\,1001\,1101\,1011_2$

  $0010_2 = 2_(16)$, $1001_2 = 9_(16)$, $1101_2 = "D"_(16)$, $1011_2 = "B"_(16)$
]

#text(weight: "bold")[Result:] $29"DB"_(16)$

---

Convert the following hexadecimal numbers to their binary equivalents.

- a) $"E"#sub[16]$

Convert each hex digit to its 4-bit binary equivalent:

#v(4pt)
#align(center)[
  #table(
    columns: (auto, auto),
    align: center + horizon,
    inset: 6pt,
    stroke: 0.5pt,
    [*Hex Digit*], [*Binary*],
    [$"E"$], [$1110$],
  )
]

#text(weight: "bold")[Result:] $1110_2$

- b) $1"C"#sub[16]$

Convert each hex digit to its 4-bit binary equivalent:

#v(4pt)
#align(center)[
  #table(
    columns: (auto, auto),
    align: center + horizon,
    inset: 6pt,
    stroke: 0.5pt,
    [*Hex Digit*], [*Binary*],
    [$1$], [$0001$],
    [$"C"$], [$1100$],
  )
]

Combine: $0001\,1100_2$ (leading zeros can be dropped).

#text(weight: "bold")[Result:] $11100_2$

- c) $"A"64#sub[16]$

Convert each hex digit to its 4-bit binary equivalent:

#v(4pt)
#align(center)[
  #table(
    columns: (auto, auto),
    align: center + horizon,
    inset: 6pt,
    stroke: 0.5pt,
    [*Hex Digit*], [*Binary*],
    [$"A"$], [$1010$],
    [$6$], [$0110$],
    [$4$], [$0100$],
  )
]

Combine: $1010\,0110\,0100_2$

#text(weight: "bold")[Result:] $101001100100_2$

- d) $1"F"."C"#sub[16]$

Convert each hex digit to its 4-bit binary equivalent:

#v(4pt)
#align(center)[
  #table(
    columns: (auto, auto),
    align: center + horizon,
    inset: 6pt,
    stroke: 0.5pt,
    [*Hex Digit*], [*Binary*],
    [$1$], [$0001$],
    [$"F"$], [$1111$],
    [$"C"$ (fractional)], [$1100$],
  )
]

Combine integer and fractional parts: $0001\,1111.1100_2$ (leading zeros can be dropped).

#text(weight: "bold")[Result:] $11111.11_2$

- e) $239.4#sub[16]$

Convert each hex digit to its 4-bit binary equivalent:

#v(4pt)
#align(center)[
  #table(
    columns: (auto, auto),
    align: center + horizon,
    inset: 6pt,
    stroke: 0.5pt,
    [*Hex Digit*], [*Binary*],
    [$2$], [$0010$],
    [$3$], [$0011$],
    [$9$], [$1001$],
    [$4$ (fractional)], [$0100$],
  )
]

Combine integer and fractional parts: $0010\,0011\,1001.0100_2$ (leading zeros can be dropped).

#text(weight: "bold")[Result:] $1000111001.01_2$
