#set page(paper: "a4", margin: 2cm)
#set text(font: "New Computer Modern", size: 11pt)

#align(center)[
  = Revision Sheet: Number Systems & Arithmetic
]

#let section(title) = {
  v(0.5em)
  text(weight: "bold", size: 13pt, fill: blue.darken(20%), title)
  line(length: 100%, stroke: 0.5pt)
  v(0.5em)
}

#section("1. Base Conversion")

*Integer to Base N (Repeated Division):*
Divide the decimal number by the target base $N$. Keep track of the remainder.
Continue dividing the quotient until it reaches 0. The result is the sequence of
remainders in *reverse order* (bottom-up).

*Example: $55_(10)$ to Base 6*
$55 div 6 = 9$ (rem 1) \
$9 div 6 = 1$ (rem 3) \
$1 div 6 = 0$ (rem 1) \
Result: $131_6$

*Fractional to Base N (Repeated Multiplication):*
Multiply the fractional part by $N$. Record the integer part of the product.
Take the remaining fractional part and repeat until the fraction becomes 0 or
you reach desired precision. Read the integer parts in *forward order*
(top-down).

*Example: $0.125_(10)$ to Base 16*
$0.125 times 16 = 2.0$ \
Result: $0.2_(16)$

---

#section("2. Binary Representation")

*Two's Complement (for $n$ bits):*
1. Write the positive binary form.
2. Invert all bits (0 becomes 1, 1 becomes 0).
3. Add 1 to the result.

*Binary to Decimal (Two's Complement):*
If the MSB is 1, the number is negative. To find its magnitude, invert all bits
and add 1, then apply the negative sign.

*Example: $1101011_2$ to decimal*
1. Invert: $0010100$
2. Add 1: $0010101 = 21$
Result: $-21$

---

#section("3. Binary/Hex Shortcut")

*Binary to Hex:* Group bits into sets of 4 starting from the radix point (the
dot), padding with zeros if necessary. Replace each 4-bit group with its
corresponding hex digit.

*Example: $110101.011_2$*
$0011$ $0101$ . $0110$ \
$= 35.6_(16)$

---

#section("4. IEEE 754 Floating Point")

*Standard Structure (Single Precision):*
`[Sign (1)] [Exponent (8)] [Mantissa/Fraction (23)]`

1. *Sign:* 0 for positive, 1 for negative.
2. *Normalize:* Convert to scientific notation ($1.f times 2^e$). The mantissa
  is the sequence $f$.
3. *Bias:* Add $127$ to the exponent $e$ to get the stored exponent value.

*Example: $-2.5$ to IEEE 754*
1. $-2.5 = -10.1_2 = -1.01 times 2^1$
2. Sign: 1
3. Exponent: $1 + 127 = 128 = 10000000_2$
4. Mantissa: $01000...0$ (trailing zeros)
Result: `1 10000000 01000000000000000000000`

---

#section("5. Floating Point Arithmetic Tips")

When performing operations:
1. *Alignment:* Shift the significand of the number with the smaller exponent
  until both exponents match.
2. *Operation:* Perform addition or subtraction on the significands.
3. *Normalize:* Adjust the resulting significand and exponent so that there is
  exactly one non-zero digit before the decimal point (e.g., $0.123 times 10^2$
  becomes $1.23 times 10^1$).
4. *Rounding:* Truncate or round to the required number of digits as specified
  in the problem (e.g., 4 digits).
