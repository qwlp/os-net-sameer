#set page(paper: "a4", margin: (
  top: 2.5cm,
  bottom: 2cm,
  left: 2.5cm,
  right: 2cm,
))
#set text(font: "New Computer Modern", size: 11pt)
#set heading(numbering: none)

#align(center + top)[
  #text(size: 16pt, weight: "bold", fill: rgb("003366"))[CTEC1704C – LAB 2]
  #text(size: 12pt, weight: "bold")[SOLUTIONS]
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

#section-title("ARITHMETIC")

#sub-title("INTEGER REPRESENTATION, ADDITION AND SUBTRACTION")

*1. Represent the following decimal numbers in both binary sign/magnitude and
twos complement using 16 bits:*

a) *+512*

+512 in binary is `0000 0010 0000 0000`. Since the number is positive, both
representations are identical:
- *Sign/Magnitude:* `0000 0010 0000 0000`
- *Twos Complement:* `0000 0010 0000 0000`

b) *-29*

First, +29 in 16-bit binary is `0000 0000 0001 1101`.

- *Sign/Magnitude:* Set the MSB to 1: `1000 0000 0001 1101`
- *Twos Complement:* Invert all bits of +29 and add 1.
  - Invert: `1111 1111 1110 0010`
  - Add 1: `1111 1111 1110 0011`

---

*2. Represent the following twos complement values in decimal:*

a) *1101011* (7 bits)

The MSB is 1, so the number is negative. Invert and add 1: `0010100` + 1 =
`0010101` = 21. Therefore, the value is *-21*.

b) *0101101* (7 bits)

The MSB is 0, so the number is positive. `0101101` = 32 + 8 + 4 + 1 = *45*.

---

*3. Assume that numbers are represented in 8-bit twos complement representation.
Show the calculation of the following:*

a) *6 + 13*

```
  0000 0110   (6)
+ 0000 1101   (13)
-----------
  0001 0011   (19)
```
Result: *19* (no overflow).

b) *-6 + 13*

-6 in 8-bit 2's complement: `1111 1010`

```
  1111 1010   (-6)
+ 0000 1101   (13)
-----------
1 0000 0111   (7)
```
Discard the carry-out. Result: *7*.

c) *6 - 13* = 6 + (-13)

-13 in 8-bit 2's complement: `1111 0011`

```
  0000 0110   (6)
+ 1111 0011   (-13)
-----------
  1111 1001
```
The result `1111 1001` is negative. Invert and add 1: `0000 0110` + 1 =
`0000 0111` = 7. Result: *-7*.

d) *-6 - 13* = (-6) + (-13)

```
  1111 1010   (-6)
+ 1111 0011   (-13)
-----------
1 1110 1101   (-19)
```
Discard the carry-out. Result: *-19*.

#pagebreak()

#section-title("FLOATING POINT NUMBERS")

*1. What decimal number does the bit pattern* `0xC0000000` *(hexadecimal)
represent if it is:*

Binary: `1100 0000 0000 0000 0000 0000 0000 0000`

a. *A twos complement integer?*

The MSB is 1, so it is negative. Magnitude = invert + 1 =
`0100 0000 0000 0000 0000 0000 0000 0000` = $2^30$ = 1,073,741,824. Result:
*-1,073,741,824*

b. *An unsigned integer?*

`0xC0000000` = 12 × $16^7$ = 12 × 268,435,456 = *3,221,225,472*

c. *A floating point number according to the IEEE 754 standard?*

- Sign bit: `1` → negative
- Exponent: `10000000` = 128. Biased value: 128 - 127 = 1
- Mantissa: `000...000` → significand = 1.0

Value = -1.0 × $2^1$ = *-2.0*

---

*2. Write down the binary representation of the decimal number* `63.25`
*assuming:*

$63.25 = 111111.01_2 = 1.1111101_2 × 2^5$

a) *IEEE 754 single precision:*

- Sign: 0
- Exponent: 5 + 127 = 132 = `10000100`
- Mantissa: `11111010000000000000000`

Full 32-bit: `0 10000100 11111010000000000000000` = `0x427D0000`

b) *IEEE 754 double precision:*

- Sign: 0
- Exponent: 5 + 1023 = 1028 = `10000000100`
- Mantissa: `1111101000...` (52 bits)

Full 64-bit: `0 10000000100 1111101000...0` = `0x404FA00000000000`

---

*3. Express the following numbers in IEEE 754 single precision format.*

a) *-8*

-8 = $-1.0_2 × 2^3$. Sign=1, Exponent=130=`10000010`, Mantissa=`000...0`

`1 10000010 00000000000000000000000` = `0xC1000000`

b) *-7*

-7 = $-1.11_2 × 2^2$. Sign=1, Exponent=129=`10000001`, Mantissa=`11000...0`

`1 10000001 11000000000000000000000` = `0xC0E00000`

c) *-2.5*

-2.5 = $-1.01_2 × 2^1$. Sign=1, Exponent=128=`10000000`, Mantissa=`01000...0`

`1 10000000 01000000000000000000000` = `0xC0200000`

d) *384*

384 = $1.1_2 × 2^8$. Sign=0, Exponent=135=`10000111`, Mantissa=`1000...0`

`0 10000111 10000000000000000000000` = `0x43C00000`

e) *1/16*

1/16 = $1.0_2 × 2^{-4}$. Sign=0, Exponent=123=`01111011`, Mantissa=`000...0`

`0 01111011 00000000000000000000000` = `0x3D800000`

---

*4. The following numbers are IEEE 754 single precision numbers. What is the
equivalent decimal value?*

a) `1 10000000 11000000000000000000000`

- Sign = negative
- Exponent = 128 → 128 - 127 = 1
- Significand = 1.11 = 1.75

Value = -1.75 × $2^1$ = *-3.5*

b) `0 01111111 00000000000000000000000`

- Sign = positive
- Exponent = 127 → 127 - 127 = 0
- Significand = 1.0

Value = +1.0 × $2^0$ = *1.0*

c) `0 10000000 11000000000000000000000`

- Sign = positive
- Exponent = 128 → 1
- Significand = 1.11 = 1.75

Value = +1.75 × $2^1$ = *3.5*

---

*5. Show how the following floating point additions are performed. Assume that
significands are truncated to 4 decimal digits. Show the results in normalized
form.*

a) $5.566 × 10^3 + 7.777 × 10^3$

Both operands share the same exponent. Add significands directly:

$5.566 + 7.777 = 13.343$

Result: $13.343 × 10^3$

Normalize: $1.3343 × 10^4$

Truncate to 4 significant digits: *$1.334 × 10^4$*

b) $3.344 × 10^1 + 8.877 × 10^{-2}$

Align exponents to the larger ($10^1$):

$8.877 × 10^{-2} = 0.008877 × 10^1$

Add: $3.344 + 0.008877 = 3.352877$

Result before truncation: $3.352877 × 10^1$

Truncate to 4 significant digits: *$3.352 × 10^1$*

c) $7.744 × 10^{-3} - 6.666 × 10^{-3}$

Same exponent. Subtract significands:

$7.744 - 6.666 = 1.078$

Result: $1.078 × 10^{-3}$ (already normalized)

Truncate to 4 significant digits: *$1.078 × 10^{-3}$*

d) $8.844 × 10^{-3} - 2.233 × 10^{-1}$

Align exponents to the larger ($10^{-1}$):

$8.844 × 10^{-3} = 0.08844 × 10^{-1}$

Subtract: $0.08844 - 2.233 = -2.14456$

Result before truncation: $-2.14456 × 10^{-1}$

Truncate to 4 significant digits: *$-2.144 × 10^{-1}$*
