#import "prelude.typ": *;
#show: styling


== Converting from Binary to Decimal

#figure(
  image("assets/bin-to-dec.png", width: 80%),
  caption: [Binary to Decimal],
) <fig-bin-to-dec>

== Converting from Decimal to Binary


#figure(
  image("assets/dec-to-bin-with-repeated-div.png", width: 80%),
  caption: [Using repeated division],
) <fig-dec-to-bin-with-repeated-div>


== Converting from Hex to Decimal and Vice Versa


- Same idea as Bin to Dec but instead its $2^16$, 0 - F (As its values)
- So Dec to Hex is the same, but instead uses division by 16

== Two complements/Signed Int

- Positive numbers are stored as binary
- Negative numbers are stored as:
  + Writing all the binary for the positive value
  + Flipping all bits
  + Adding 1

- To convert from 2's complement back to decimal:
  + Flip the bits
  + Add 1
  + Take account the leftmost bit

The "leftmost bit" will be what the sign is.

= Overflows

- Happens when you either have
  + Pos + Pos = Neg
  + Neg + Neg = Pos

= Floating Points

Let's say you want to convert $13.25$ to a 32-bit floating point IEEE 754
number.

```
[ sign ] [ exponent ] [fraction ]
```

- The sign will 1 bit, exponent 8 bits and fraction 23 bits
- First we convert the 13.25 in binary
  + 13 to bin = 1101
  + 0.25 to bin = .01
    - Times 2 trick:
      - $0.25 times 2 = 0.5 -> 0$
      - $0.5 times 2 = 1.0 -> 1$
      - So you do it till its 0.0, so the ans would be 0.01
- Then we normalize it:
  + $1101.01 = 1.10101 times 2^3$.
  + The exponent is 3, the sign is 0 (positive) and the fraction part is 10101.
  + The exponent needs some bias so, since it is 3, take it plus (127) = 130.
  + 130 in bin is 10000010.
  + Fraction part is 10101, since the fraction part has 23 bits, just make sure
    its 23, so it becomes 10101000000000000000000.

```
sign      exponent            fraction
 0       10000010      10101000000000000000000
```

- The answer would be 01000001010101000000000000000000.

Let's say you want to convert a 32-bit floating point IEEE 754 number back to
decimal.

[ sign ] [ exponent ] [ fraction ]

- The sign is 1 bit, exponent is 8 bits, and fraction is 23 bits.
- First, split the binary number into its parts:
  + sign = 0
  + exponent = 10000010
  + fraction = 10101000000000000000000

- Read the sign:
  + 0 means positive

- Convert the exponent back to decimal:
  + 10000010 in binary = 130
  + The bias is 127, so actual exponent = 130 - 127 = 3

- Rebuild the normalized number:
  + Add the implied leading 1 to the fraction
  + 1.10101 × 2^3

- Convert back to decimal:
  + 1.10101 × 2^3 = 1101.01₂
  + 1101₂ = 13
  + .01₂ = 0.25
  + So the answer is 13.25
