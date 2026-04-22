#let bg = rgb("#0f172a")
#let panel = rgb("#111827")
#let panel-soft = rgb("#172554")
#let panel-accent = rgb("#1e293b")
#let ink = rgb("#e5eefb")
#let muted = rgb("#bfd2f4")
#let accent = rgb("#7dd3fc")
#let accent-2 = rgb("#fbbf24")
#let accent-3 = rgb("#86efac")
#let line = rgb("#334155")

#set page(
  width: 13.333in,
  height: 7.5in,
  margin: (x: 0.55in, y: 0.42in),
  fill: bg,
)

#set text(size: 17pt, fill: ink)
#set par(justify: false, leading: 1.02em)

#show heading.where(level: 1): it => block(above: 0pt, below: 14pt)[
  #text(size: 24pt, weight: "bold", fill: accent)[#it.body]
]

#show heading.where(level: 2): it => block(above: 6pt, below: 8pt)[
  #text(size: 18pt, weight: "bold", fill: accent-2)[#it.body]
]

#let digits = (
  "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
  "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
  "U", "V", "W", "X", "Y", "Z",
)

#let collect-steps(n, base) = {
  if n == 0 {
    ((0,), (0,), ("0",))
  } else {
    let inner(current) = {
      if current == 0 {
        ((), (), ())
      } else {
        let rem = calc.rem(current, base)
        let next = calc.floor(current / base)
        let rest = inner(next)
        (
          (current,) + rest.at(0),
          (rem,) + rest.at(1),
          rest.at(2) + (digits.at(rem),),
        )
      }
    }
    inner(n)
  }
}

#let conversion-table(number, base) = {
  let steps = collect-steps(number, base)
  let numerators = steps.at(0)
  let remainders = steps.at(1)
  let symbols = steps.at(2)
  let rows = range(numerators.len()).map(i => (
    [#numerators.at(i)],
    [$div$],
    [#base],
    [#calc.floor(numerators.at(i) / base)],
    [#remainders.at(i)],
    [#symbols.at(i)],
  )).flatten()

  table(
    columns: 6,
    align: center + horizon,
    inset: 6pt,
    stroke: (paint: line, thickness: 0.7pt),
    fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
    [*Dividend*], [*Op*], [*Base*], [*Quotient*], [*Remainder*], [*Digit*],
    ..rows,
  )
}

#let result-card(label, value, fill-color: panel-soft) = block(
  fill: fill-color,
  inset: 9pt,
  radius: 10pt,
  stroke: (paint: accent, thickness: 0.6pt),
)[
  #text(weight: "bold", fill: accent-2)[#label]
  #v(3pt)
  #text(size: 19pt, weight: "bold")[#value]
]

#let note-card(title, body) = block(
  fill: panel,
  inset: 9pt,
  radius: 10pt,
  stroke: (paint: line, thickness: 0.7pt),
)[
  #text(weight: "bold", fill: accent-3)[#title]
  #v(3pt)
  #body
]

#let slide(title, body) = [
  = #title
  #body
  #pagebreak()
]

#slide(
  [Lab 1 Slide Deck],
  [
    #grid(
      columns: (1.4fr, 1fr),
      column-gutter: 18pt,
      [
        #block(fill: panel, inset: 18pt, radius: 14pt, stroke: (paint: accent, thickness: 0.8pt))[
          #text(size: 29pt, weight: "bold")[Number Systems and Base Conversion]
          #v(6pt)
          #text(fill: muted)[Slide version of `Lab 1.typ` with worked answers, conversion tables, and math notation.]
          #v(10pt)
          #text(fill: accent-2, weight: "bold")[Coverage]
          - Counting in bases $8$, $5$, and $3$
          - Integer conversions across binary, octal, decimal, hexadecimal, base $6$, and base $7$
          - Fractional conversions, significance of digits, and binary/hex grouping rules
        ]
      ],
      [
        #note-card([Core Rules], [
          - For integer conversion from decimal to base $b$, repeatedly divide by $b$ and read remainders from bottom to top.
          - For fractional conversion from decimal to base $b$, repeatedly multiply by $b$ and read integer parts from top to bottom.
          - For expansion to decimal, use weighted sums:
            $
              (d_n d_(n-1) dots d_0.d_(-1) d_(-2))_b
              = sum_(k=0)^n d_k b^k + sum_(k=1)^m d_(-k) b^(-k).
            $
        ])
      ],
    )
  ],
)

#slide(
  [Counting from $1$ to $20_{10}$ in Other Bases],
  [
    #table(
      columns: 4,
      align: center + horizon,
      inset: 6pt,
      stroke: (paint: line, thickness: 0.7pt),
      fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
      [*Decimal*], [*Base $8$*], [*Base $5$*], [*Base $3$*],
      [$1$], [$1_8$], [$1_5$], [$1_3$],
      [$2$], [$2_8$], [$2_5$], [$2_3$],
      [$3$], [$3_8$], [$3_5$], [$10_3$],
      [$4$], [$4_8$], [$4_5$], [$11_3$],
      [$5$], [$5_8$], [$10_5$], [$12_3$],
      [$6$], [$6_8$], [$11_5$], [$20_3$],
      [$7$], [$7_8$], [$12_5$], [$21_3$],
      [$8$], [$10_8$], [$13_5$], [$22_3$],
      [$9$], [$11_8$], [$14_5$], [$100_3$],
      [$10$], [$12_8$], [$20_5$], [$101_3$],
    )
  ],
)

#slide(
  [Counting from $11$ to $20_{10}$ in Other Bases],
  [
    #table(
      columns: 4,
      align: center + horizon,
      inset: 6pt,
      stroke: (paint: line, thickness: 0.7pt),
      fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
      [*Decimal*], [*Base $8$*], [*Base $5$*], [*Base $3$*],
      [$11$], [$13_8$], [$21_5$], [$102_3$],
      [$12$], [$14_8$], [$22_5$], [$110_3$],
      [$13$], [$15_8$], [$23_5$], [$111_3$],
      [$14$], [$16_8$], [$24_5$], [$112_3$],
      [$15$], [$17_8$], [$30_5$], [$120_3$],
      [$16$], [$20_8$], [$31_5$], [$121_3$],
      [$17$], [$21_8$], [$32_5$], [$122_3$],
      [$18$], [$22_8$], [$33_5$], [$200_3$],
      [$19$], [$23_8$], [$34_5$], [$201_3$],
      [$20$], [$24_8$], [$40_5$], [$202_3$],
    )
    #v(10pt)
    #note-card([Pattern], [
      The place values in base $b$ are $b^0, b^1, b^2, dots$. Once the last single digit is reached, the next number increments the next place:
      $7_8 → 10_8$, $4_5 → 10_5$, and $2_3 → 10_3$.
    ])
  ],
)

#slide(
  [Method for Integer Conversion],
  [
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 18pt,
      [
        #note-card([To Decimal], [
          Expand the numeral as a weighted polynomial in its base.
          #v(6pt)
          $
            (a_m a_(m-1) dots a_0)_b
            = a_m b^m + a_(m-1) b^(m-1) + dots + a_0 b^0.
          $
          #v(8pt)
          Example:
          $
            67_8 = 6 times 8^1 + 7 times 8^0 = 48 + 7 = 55_(10).
          $
        ])
      ],
      [
        #note-card([From Decimal to Base $b$], [
          Repeatedly divide by $b$:
          - quotient goes to the next row,
          - remainder becomes the next digit,
          - final answer is read from the last remainder upward.
          #v(6pt)
          If a remainder is $10$ to $15$ in base $16$, use
          $
            10 → "A", 11 → "B", 12 → "C", 13 → "D", 14 → "E", 15 → "F".
          $
        ])
      ],
    )
    #v(12pt)
    #result-card([General Result], [$N = (r_k r_(k-1) dots r_1 r_0)_b$ where each $r_i$ is the remainder sequence read in reverse order.], fill-color: panel)
  ],
)

#slide(
  [Convert $67_8$ to Bases $6$ and $7$],
  [
    #note-card([Step 1: Convert to Decimal], [
      $
        67_8 = 6 times 8^1 + 7 times 8^0 = 48 + 7 = 55_(10).
      $
    ])
    #v(10pt)
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 18pt,
      [
        #text(weight: "bold", fill: accent-2)[To Base $6$]
        #v(6pt)
        #conversion-table(55, 6)
        #v(8pt)
        #result-card([Answer], [$55_(10) = 131_6$])
      ],
      [
        #text(weight: "bold", fill: accent-2)[To Base $7$]
        #v(6pt)
        #conversion-table(55, 7)
        #v(8pt)
        #result-card([Answer], [$55_(10) = 106_7$])
      ],
    )
  ],
)

#slide(
  [Convert $91_{10}$ to Bases $6$ and $7$],
  [
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 18pt,
      [
        #text(weight: "bold", fill: accent-2)[To Base $6$]
        #v(6pt)
        #conversion-table(91, 6)
        #v(8pt)
        #result-card([Answer], [$91_(10) = 231_6$])
      ],
      [
        #text(weight: "bold", fill: accent-2)[To Base $7$]
        #v(6pt)
        #conversion-table(91, 7)
        #v(8pt)
        #result-card([Answer], [$91_(10) = 160_7$])
      ],
    )
  ],
)

#slide(
  [Convert $75_{16}$ to Bases $6$ and $7$],
  [
    #note-card([Step 1: Convert to Decimal], [
      $
        75_(16) = 7 times 16^1 + 5 times 16^0 = 112 + 5 = 117_(10).
      $
    ])
    #v(10pt)
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 18pt,
      [
        #text(weight: "bold", fill: accent-2)[To Base $6$]
        #v(6pt)
        #conversion-table(117, 6)
        #v(8pt)
        #result-card([Answer], [$117_(10) = 313_6$])
      ],
      [
        #text(weight: "bold", fill: accent-2)[To Base $7$]
        #v(6pt)
        #conversion-table(117, 7)
        #v(8pt)
        #result-card([Answer], [$117_(10) = 225_7$])
      ],
    )
  ],
)

#slide(
  [Convert $11001_2$ to Bases $6$ and $7$],
  [
    #note-card([Step 1: Convert to Decimal], [
      $
        11001_2
        = 1 times 2^4 + 1 times 2^3 + 0 times 2^2 + 0 times 2^1 + 1 times 2^0
        = 16 + 8 + 1
        = 25_(10).
      $
    ])
    #v(10pt)
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 18pt,
      [
        #text(weight: "bold", fill: accent-2)[To Base $6$]
        #v(6pt)
        #conversion-table(25, 6)
        #v(8pt)
        #result-card([Answer], [$25_(10) = 41_6$])
      ],
      [
        #text(weight: "bold", fill: accent-2)[To Base $7$]
        #v(6pt)
        #conversion-table(25, 7)
        #v(8pt)
        #result-card([Answer], [$25_(10) = 34_7$])
      ],
    )
  ],
)

#slide(
  [Decimal to Hexadecimal and Binary: $24_{10}$ and $454_{10}$],
  [
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 18pt,
      [
        #note-card([$24_(10)$], [
          $
            24 div 16 = 1, "remainder" 8
          $
          #v(3pt)
          $
            1 div 16 = 0, "remainder" 1
          $
          #v(6pt)
          Therefore
          $
            24_(10) = 18_(16).
          $
          #v(6pt)
          Also,
          $
            24_(10) = 11000_2.
          $
        ])
      ],
      [
        #note-card([$454_(10)$], [
          $
            454 = 1 times 16^2 + 12 times 16 + 6
          $
          so
          $
            454_(10) = 1"C"6_(16).
          $
          #v(6pt)
          Binary by repeated division or from hex:
          $
            1 → 0001, "C" → 1100, 6 → 0110.
          $
          #v(3pt)
          Hence
          $
            454_(10) = 111000110_2.
          $
        ])
      ],
    )
    #v(12pt)
    #table(
      columns: 3,
      align: center + horizon,
      inset: 6pt,
      stroke: (paint: line, thickness: 0.7pt),
      fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
      [*Decimal*], [*Hexadecimal*], [*Binary*],
      [$24$], [$18_(16)$], [$11000_2$],
      [$454$], [$1"C"6_(16)$], [$111000110_2$],
    )
  ],
)

#slide(
  [Decimal to Hexadecimal and Binary: $6550_{10}$],
  [
    #grid(
      columns: (1.1fr, 0.9fr),
      column-gutter: 18pt,
      [
        #text(weight: "bold", fill: accent-2)[Repeated Division by $16$]
        #v(6pt)
        #table(
          columns: 3,
          align: center + horizon,
          inset: 6pt,
          stroke: (paint: line, thickness: 0.7pt),
          fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
          [*Division*], [*Quotient*], [*Remainder*],
          [$6550 div 16$], [$409$], [$6$],
          [$409 div 16$], [$25$], [$9$],
          [$25 div 16$], [$1$], [$9$],
          [$1 div 16$], [$0$], [$1$],
        )
      ],
      [
        #note-card([Result], [
          Reading the remainders from bottom to top gives
          $
            6550_(10) = 1996_(16).
          $
          #v(6pt)
          Convert each hex digit to binary:
          $
            1 → 0001,
            9 → 1001,
            9 → 1001,
            6 → 0110.
          $
          #v(3pt)
          Therefore
          $
            6550_(10) = 1100110010110_2.
          $
        ])
      ],
    )
  ],
)

#slide(
  [From Octal to Hex and Binary: $27_8$ and $6325_8$],
  [
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 18pt,
      [
        #note-card([$27_8$], [
          $
            27_8 = 2 times 8^1 + 7 times 8^0 = 16 + 7 = 23_(10).
          $
          #v(6pt)
          $
            23_(10) = 17_(16) = 10111_2.
          $
        ])
      ],
      [
        #note-card([$6325_8$], [
          $
            6325_8
            = 6 times 8^3 + 3 times 8^2 + 2 times 8^1 + 5 times 8^0
          $
          $
            = 3072 + 192 + 16 + 5 = 3285_(10).
          $
          #v(6pt)
          Repeated division by $16$ gives
          $
            3285_(10) = "CD"5_(16).
          $
          #v(6pt)
          Hex to binary:
          $
            "C" = 1100, "D" = 1101, 5 = 0101,
          $
          so
          $
            6325_8 = 110011010101_2.
          $
        ])
      ],
    )
  ],
)

#slide(
  [From Octal to Hex and Binary: Summary Table],
  [
    #table(
      columns: 4,
      align: center + horizon,
      inset: 6pt,
      stroke: (paint: line, thickness: 0.7pt),
      fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
      [*Original*], [*Decimal*], [*Hex*], [*Binary*],
      [$27_8$], [$23$], [$17_(16)$], [$10111_2$],
      [$6325_8$], [$3285$], [$"CD"5_(16)$], [$110011010101_2$],
    )
  ],
)

#slide(
  [Binary to Decimal and Hexadecimal],
  [
    #table(
      columns: 4,
      align: center + horizon,
      inset: 6pt,
      stroke: (paint: line, thickness: 0.7pt),
      fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
      [*Binary*], [*Decimal Expansion*], [*Decimal*], [*Hexadecimal*],
      [$1101_2$], [$1 times 2^3 + 1 times 2^2 + 0 times 2 + 1$], [$13$], [$"D"_(16)$],
      [$1000110_2$], [$1 times 2^6 + 1 times 2^2 + 1 times 2^1$], [$70$], [$46_(16)$],
      [$111111_2$], [$2^5 + 2^4 + 2^3 + 2^2 + 2^1 + 2^0$], [$63$], [$3"F"_(16)$],
    )
    #v(12pt)
    #note-card([Why Hex is Fast], [
      Group binary digits into chunks of four:
      $
        1101_2 = "D"_(16), 
        1000110_2 = 0100 0110_2 = 46_(16).
      $
      Each hexadecimal digit represents exactly $4$ binary bits.
    ])
  ],
)

#slide(
  [Most Significant and Least Significant Digits],
  [
    #table(
      columns: 4,
      align: center + horizon,
      inset: 6pt,
      stroke: (paint: line, thickness: 0.7pt),
      fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
      [*Number*], [*MSD*], [*LSD*], [*Reason*],
      [$441.34$], [$4$], [$4$], [Leftmost non-zero digit is $4$; rightmost written digit is $4$.],
      [$0.245$], [$0$], [$5$], [Using the written form, the leftmost digit is $0$ and the rightmost digit is $5$.],
      [$234.00$], [$2$], [$0$], [The first digit is $2$; the last written digit is the final $0$ in the fractional part.],
    )
    #v(12pt)
    #note-card([Interpretation], [
      The *most significant digit* contributes the largest positional weight.
      The *least significant digit* contributes the smallest positional weight among the written digits.
      For fractional numerals, the LSD is often in the fractional tail.
    ])
  ],
)

#slide(
  [Convert $204.125_{10}$ to Hexadecimal],
  [
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 18pt,
      [
        #text(weight: "bold", fill: accent-2)[Integer Part: $204$]
        #v(6pt)
        #table(
          columns: 3,
          align: center + horizon,
          inset: 6pt,
          stroke: (paint: line, thickness: 0.7pt),
          fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
          [*Division*], [*Quotient*], [*Remainder*],
          [$204 div 16$], [$12$], [$12 = "C"$],
          [$12 div 16$], [$0$], [$12 = "C"$],
        )
      ],
      [
        #text(weight: "bold", fill: accent-2)[Fractional Part: $0.125$]
        #v(6pt)
        #table(
          columns: 3,
          align: center + horizon,
          inset: 6pt,
          stroke: (paint: line, thickness: 0.7pt),
          fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
          [*Multiplication*], [*Product*], [*Integer Part*],
          [$0.125 times 16$], [$2.0$], [$2$],
        )
      ],
    )
    #v(10pt)
    #note-card([Assemble the Answer], [
      Integer part:
      $
        204_(10) = "CC"_(16).
      $
      Fractional part:
      $
        0.125_(10) = .2_(16).
      $
      Therefore
      $
        204.125_(10) = "CC".2_(16).
      $
    ])
  ],
)

#slide(
  [Convert $631.25_{10}$ to Hexadecimal],
  [
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 18pt,
      [
        #text(weight: "bold", fill: accent-2)[Integer Part: $631$]
        #v(6pt)
        #table(
          columns: 3,
          align: center + horizon,
          inset: 6pt,
          stroke: (paint: line, thickness: 0.7pt),
          fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
          [*Division*], [*Quotient*], [*Remainder*],
          [$631 div 16$], [$39$], [$7$],
          [$39 div 16$], [$2$], [$7$],
          [$2 div 16$], [$0$], [$2$],
        )
      ],
      [
        #text(weight: "bold", fill: accent-2)[Fractional Part: $0.25$]
        #v(6pt)
        #table(
          columns: 3,
          align: center + horizon,
          inset: 6pt,
          stroke: (paint: line, thickness: 0.7pt),
          fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
          [*Multiplication*], [*Product*], [*Integer Part*],
          [$0.25 times 16$], [$4.0$], [$4$],
        )
      ],
    )
    #v(10pt)
    #note-card([Assemble the Answer], [
      Integer part:
      $
        631_(10) = 277_(16).
      $
      Fractional part:
      $
        0.25_(10) = .4_(16).
      $
      Hence
      $
        631.25_(10) = 277.4_(16).
      $
    ])
  ],
)

#slide(
  [Binary Fractions to Hexadecimal],
  [
    #table(
      columns: 4,
      align: center + horizon,
      inset: 6pt,
      stroke: (paint: line, thickness: 0.7pt),
      fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
      [*Binary*], [*Grouping*], [*Hex*], [*Reason*],
      [$1001.1111_2$], [$1001 . 1111$], [$9."F"_(16)$], [Each 4-bit group maps directly to one hex digit.],
      [$110101.011001_2$], [$0011 0101 . 0110 0100$], [$35.64_(16)$], [Pad on the left of the integer part and on the right of the fractional part.],
      [$10100111011011_2$], [$0010 1001 1101 1011$], [$29"DB"_(16)$], [The grouped nibbles are $0010$, $1001$, $1101$, $1011$.],
    )
    #v(12pt)
    #note-card([Grouping Rule], [
      For the integer part, group bits from the right.
      For the fractional part, group bits from the left.
      Padding zeros do not change the value when they are added on the outer side of the grouping.
    ])
  ],
)

#slide(
  [Hexadecimal to Binary],
  [
    #table(
      columns: 4,
      align: center + horizon,
      inset: 6pt,
      stroke: (paint: line, thickness: 0.7pt),
      fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
      [*Hexadecimal*], [*Nibble Expansion*], [*Binary*], [*Simplified Form*],
      [$"E"_(16)$], [$"E" → 1110$], [$1110_2$], [$1110_2$],
      [$1"C"_(16)$], [$1 → 0001, "C" → 1100$], [$0001 1100_2$], [$11100_2$],
      [$"A"64_(16)$], [$"A" → 1010, 6 → 0110, 4 → 0100$], [$1010 0110 0100_2$], [$101001100100_2$],
      [$1"F"."C"_(16)$], [$1 → 0001, "F" → 1111, "C" → 1100$], [$0001 1111.1100_2$], [$11111.11_2$],
      [$239.4_(16)$], [$2 → 0010, 3 → 0011, 9 → 1001, 4 → 0100$], [$0010 0011 1001.0100_2$], [$1000111001.01_2$],
    )
  ],
)

#slide(
  [IEEE 754 Single Precision Overview],
  [
    #grid(
      columns: (0.92fr, 1.08fr),
      column-gutter: 18pt,
      [
        #note-card([Bit Layout], [
          #table(
            columns: 4,
            align: center + horizon,
            inset: 6pt,
            stroke: (paint: line, thickness: 0.7pt),
            fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
            [*Field*], [*Bits*], [*Meaning*], [*Width*],
            [Sign], [$s$], [Positive or negative], [$1$],
            [Exponent], [$e$], [Biased exponent], [$8$],
            [Fraction], [$f$], [Mantissa after the hidden leading $1$], [$23$],
          )
          #v(8pt)
          #result-card([Stored Pattern], [`s eeeeeeee fffffffffffffffffffffff`], fill-color: panel)
        ])
      ],
      [
        #note-card([Value Formula], [
          For a normalized 32-bit float,
          $
            "value" = (-1)^s times (1.f)_2 times 2^(e - 127).
          $
          #v(6pt)
          Here $127$ is the bias, so the true exponent is
          $
            E = e - 127.
          $
          #v(6pt)
          Flow:
          - Convert the decimal value to binary.
          - Normalize it to the form $1."xxxxx" times 2^E$.
          - Store the sign bit.
          - Add the bias to get the exponent field.
          - Store the fractional part after the leading $1$ in the mantissa.
        ])
      ],
    )
  ],
)

#slide(
  [Convert $13.25_{10}$ to IEEE 754 32-bit],
  [
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 18pt,
      [
        #note-card([Step 1: Convert to Binary], [
          Integer part:
          $
            13_(10) = 1101_2.
          $
          Fractional part:
          #table(
            columns: 3,
            align: center + horizon,
            inset: 6pt,
            stroke: (paint: line, thickness: 0.7pt),
            fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
            [*Multiply by $2$*], [*Result*], [*Next Bit*],
            [$0.25 times 2$], [$0.5$], [$0$],
            [$0.5 times 2$], [$1.0$], [$1$],
          )
          Thus
          $
            0.25_(10) = 0.01_2
          $
          and
          $
            13.25_(10) = 1101.01_2.
          $
        ])
      ],
      [
        #note-card([Step 2: Normalize and Encode], [
          Normalize:
          $
            1101.01_2 = 1.10101_2 times 2^3.
          $
          So:
          - sign bit $s = 0$
          - actual exponent $E = 3$
          - biased exponent $e = 3 + 127 = 130 = 10000010_2$
          - mantissa $f = 10101000000000000000000$
          #v(6pt)
          #table(
            columns: 3,
            align: center + horizon,
            inset: 6pt,
            stroke: (paint: line, thickness: 0.7pt),
            fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
            [*Sign*], [*Exponent*], [*Fraction*],
            [$0$], [$10000010$], [$10101000000000000000000$],
          )
          #v(6pt)
          #text(weight: "bold", fill: accent-2)[Final 32-bit pattern:]
          $
            01000001010101000000000000000000
          $
        ])
      ],
    )
  ],
)

#slide(
  [Convert $-5.75_{10}$ to IEEE 754 32-bit],
  [
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 18pt,
      [
        #note-card([Step 1: Binary Form], [
          Magnitude:
          $
            5_(10) = 101_2.
          $
          Fraction:
          #table(
            columns: 3,
            align: center + horizon,
            inset: 6pt,
            stroke: (paint: line, thickness: 0.7pt),
            fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
            [*Multiply by $2$*], [*Result*], [*Next Bit*],
            [$0.75 times 2$], [$1.5$], [$1$],
            [$0.5 times 2$], [$1.0$], [$1$],
          )
          Hence
          $
            0.75_(10) = 0.11_2
          $
          and
          $
            5.75_(10) = 101.11_2.
          $
        ])
      ],
      [
        #note-card([Step 2: Normalize and Encode], [
          Normalize:
          $
            101.11_2 = 1.0111_2 times 2^2.
          $
          So:
          - sign bit $s = 1$ because the number is negative
          - actual exponent $E = 2$
          - biased exponent $e = 2 + 127 = 129 = 10000001_2$
          - mantissa $f = 01110000000000000000000$
          #v(6pt)
          #table(
            columns: 3,
            align: center + horizon,
            inset: 6pt,
            stroke: (paint: line, thickness: 0.7pt),
            fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
            [*Sign*], [*Exponent*], [*Fraction*],
            [$1$], [$10000001$], [$01110000000000000000000$],
          )
          #v(6pt)
          #text(weight: "bold", fill: accent-2)[Final 32-bit pattern:]
          $
            11000000101110000000000000000000
          $
        ])
      ],
    )
  ],
)

#slide(
  [Decode an IEEE 754 32-bit Pattern: Parse Fields],
  [
    #note-card([Example Pattern], [
      Decode
      $
        01000001010101000000000000000000.
      $
    ])
    #v(10pt)
    #table(
      columns: 4,
      align: center + horizon,
      inset: 6pt,
      stroke: (paint: line, thickness: 0.7pt),
      fill: (x, y) => if y == 0 { panel-soft } else if calc.rem(y, 2) == 1 { panel } else { panel-accent },
      [*Field*], [*Bits*], [*Value*], [*Interpretation*],
      [Sign], [$0$], [$0$], [Positive number],
      [Exponent], [$10000010$], [$130$], [$E = 130 - 127 = 3$],
      [Fraction], [$10101000000000000000000$], [$0.10101_2$], [Hidden leading $1$ gives $1.10101_2$],
    )
  ],
)

= Decode an IEEE 754 32-bit Pattern: Reconstruct Value
#note-card([Reconstruct the Number], [
  From the parsed fields:
  - sign $= 0$
  - exponent $= 10000010_2 = 130$, so $E = 3$
  - significand $= 1.10101_2$
  #v(6pt)
  Apply the formula:
  $
    "value" = (-1)^0 times 1.10101_2 times 2^3.
  $
  Shift the binary point right by $3$ places:
  $
    1.10101_2 times 2^3 = 1101.01_2.
  $
  Convert to decimal:
  $
    1101_2 = 13,\qquad 0.01_2 = 0.25.
  $
  Therefore
  $
    01000001010101000000000000000000 = 13.25_(10).
  $
])
