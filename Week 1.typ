#set par(
  leading: 1.5em,
  spacing: 1.5em,
)

#show heading: set block(spacing: 1.5em)

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
