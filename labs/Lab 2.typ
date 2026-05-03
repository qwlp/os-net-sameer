#set page(paper: "a4", margin: (
  top: 2.5cm,
  bottom: 2cm,
  left: 2.5cm,
  right: 2cm,
))
#set text(font: "New Computer Modern", size: 11pt)
#set heading(numbering: none)

#align(center + top)[
  #v(0.3cm)
  #text(size: 16pt, weight: "bold", fill: rgb("003366"))[CTEC1704C – LAB 2]
  #v(0.5cm)
]

#let section-title(title) = {
  rect(
    width: 100%,
    fill: rgb("4472C4"),
    stroke: none,
    inset: 8pt,
    text(fill: white, weight: "bold", size: 12pt, title),
  )
}

#let sub-title(title) = {
  v(0.3cm)
  text(weight: "bold", size: 11pt, fill: rgb("404040"), title)
  v(0.2cm)
}

#let answer-space(lines: 4, label: "") = {
  if label != "" {
    text(style: "italic", size: 10pt, label)
    v(0.1cm)
  }
  for i in range(lines) {
    line(length: 100%, stroke: 0.5pt + rgb("AAAAAA"))
    v(0.5cm)
  }
  v(0.2cm)
}


#section-title("ARITHMETIC")

#sub-title("INTEGER REPRESENTATION, ADDITION AND SUBTRACTION")

1. Represent the following decimal numbers in both binary sign/magnitude and
  twos complement using 16 bits:

a) +512
$
  +512_2 = 0000 0010 0000 0000_16
  "Two complement": 0000 0010 0000 0000_16
$

b) -29
$
  -29_2 = 0000 0000 0001 1101_16
  "Two complement": 1111 1111 1110 0011_16
$

2. Represent the following twos complement values in decimal:

a) 1101011

The MSB is 1, so the number is negative.

Invert and add 1: `0010100` + 1 = `0010101` = 21. Therefore, the value is *-21*.

b) 0101101

The MSB is 0, so the number is positive.

`0101101` = 32 + 8 + 4 + 1 = *45*.



3. Assume that numbers are represented in 8-bit twos complement representation.
  Show the calculation of the following:

a) $6 + 13$

```
  0000 0110   (6)
+ 0000 1101   (13)
-----------
  0001 0011   (19)
```
Result: *19* (no overflow).

b) $-6 + 13$

```
  1111 1010   (-6)
+ 0000 1101   (13)
-----------
1 0000 0011   (7)
```
Result: *7* (no overflow).


c) $6 - 13$
#answer-space(lines: 3)

d) $-6 - 13$
#answer-space(lines: 3)

#pagebreak()

#section-title("FLOATING POINT NUMBERS")

1. What decimal number does the bit pattern `0xC0000000` (note that this is
  hexadecimal!) represent if it is

  a. A twos complement integer?
  #answer-space(lines: 2)

  b. An unsigned integer?
  #answer-space(lines: 2)

  c. A floating point number according to the IEEE 754 standard?
  #answer-space(lines: 3)

2. Write down the binary representation of the decimal number $63.25$ assuming:

  a) the IEEE 754 single precision format.
  #answer-space(lines: 3)

  b) the IEEE 754 double precision format.
  #answer-space(lines: 3)

3. Express the following numbers in IEEE 754 single precision format.

  a) $-8$
  #answer-space(lines: 2)

  b) $-7$
  #answer-space(lines: 2)

  c) $-2.5$
  #answer-space(lines: 2)

  d) $384$
  #answer-space(lines: 2)

  e) $1/16$
  #answer-space(lines: 2)

4. The following numbers are IEEE 754 single precision numbers. What is the
  equivalent decimal value?

  a) `1 10000000 11000000000000000000000`
  #answer-space(lines: 2)

  b) `0 01111111 00000000000000000000000`
  #answer-space(lines: 2)

  c) `0 10000000 11000000000000000000000`
  #answer-space(lines: 2)

5. Show how the following floating point additions are performed. Assume that
  significands are truncated to 4 decimal digits. Show the results in normalized
  form.

  You can work with the decimal notation here – you do not need to convert the
  numbers to the binary floating point notation.

  a) $5.566 times 10^3 + 7.777 times 10^3$
  #answer-space(lines: 3)

  b) $3.344 times 10^1 + 8.877 times 10^(-2)$
  #answer-space(lines: 3)

  c) $7.744 times 10^(-3) - 6.666 times 10^(-3)$
  #answer-space(lines: 3)

  d) $8.844 times 10^(-3) - 2.233 times 10^(-1)$
  #answer-space(lines: 3)
