#import "prelude.typ": *;
#show: styling

= CPU

- Hardware is the physical component of a computer.
- Tech continues to evolve rapidly by:
  - Increased capacity, performance and reduced cost.


#figure(
  image("assets/techevolve.png", width: 80%),
  caption: [Key Takeaway: performance has increased exponentially while cost has
    decreased],
) <fig-techevolve>

== Inside the PC
- Computer systems have four parts:
  + Hardware: physical components (e.g., CPU, RAM, Disk, Mouse, Keyboard)
  + Software: system software, applications, middleware
    - Middleware: Software that acts as an intermediary between different
      systems or applications, facilitating their interaction and communication.
  + Information processed by the system
  + User: people involved in using the system

=== Inside the CPU

#figure(
  image("assets/applea5.png", width: 80%),
  caption: [Apple A5 CPU],
) <fig-applea5>

- The CPU has many core configurations. Here are some:
- Single core: One processing unit.
- Dual core: Two processing units.
- Quad core: Four processing units.
- Octa core: Eight processing units.
- Multi-core: General term for processors containing two or more independent
  cores.

Furthermore, there is deca-core (for 10 core)..., basically the more the cores
the better the multitasking and parallel processing.


#figure(
  image("assets/sometechtrends.png", width: 80%),
  caption: [Tech trends in recent decades],
) <fig-sometechtrends>

=== Moore's Law

Gordon Moore (co-founder of Intel) observed in 1965 that the number of
transistors on a microchip doubles approximately every two years, while the cost
of computers is halved. This trend has driven the rapid advancement of computing
power for decades, though it is currently slowing down as we approach the
physical limits of silicon manufacturing.


#figure(
  image("assets/mooreslaw.png", width: 80%),
  caption: [As of 2015: progress has slowed, doubling every 2.5 years],
) <fig-mooreslaw>

== Logic Gates

Computer are built of tiny switches (that can turn on (1) and off (0)) called
transistors, by combining a bunch of transistors you can get *logic gates*.

Examples:
- AND : Output is 1 only if both inputs are 1.
- OR : Output is 1 if either both inputs are 1.
- NOT : Flips the input ($1->0 , 0 ->1$)
- NAND & NOR : All in one circuits, meaning they are functionally complete.

Combination Circuits are circuits that only look at the current input (Ex: Logic
Gates). They don't "remember" anything.

Sequential Circuits, on the other hand, looks at the current input and what
happened in the past. To do this, they use Flip-Flops, which act as a 1 bit
cell.

To watch: https://www.youtube.com/watch?v=Hi7rK0hZnfc

== Memory

- SRAM (Static RAM): Used for Cache (close to the CPU). It is very fast,
  expensive, and uses multiple transistors per bit, not just one. It does not
  need to be refreshed.
- DRAM (Dynamic RAM): Used in Main Memory. It is slower but cheaper, denser, and
  users a capacitor to store charges. Since these capacitor can leak, they need
  to be refreshed.
- Flash & Disk: Used for long term storage.

#pagebreak()

== Practice

1. Given the MIPS instruction give a run down on the 5 CPU stages to make this
  instruction happen.

```asm
add $s0, $s1, $s2
```

#table(
  columns: (auto, 1fr),
  inset: 10pt,
  align: (center, left),
  fill: (x, y) => if calc.odd(y) { luma(240) } else { white },
  table.header([*Stage*], [*Action for `add $s0, $s1, $s2`*]),
  [IF], [Fetch the instruction from memory and increment the Program Counter.],
  [ID],
  [Decode instruction; read values of `$s1` and `$s2` from the Register File.],

  [EX], [ALU calculates the sum of the values from `$s1` and `$s2`.],
  [MEM], [No memory access needed; the sum simply passes through this stage.],
  [WB], [Write the sum result back into the register `$s0`.],
)

2. Convert the C code into MIPS ASM.

```c
if ( i != j ) f = g + h;
else f = g - h;
```

Solution:

```asm
# Compare i and j
    bne $s3, $s4, L1    # if (i != j) goto L1

    # Else block: f = g - h
    sub $s0, $s1, $s2   # f = g - h
    j L2                # jump to end (skip L1)

L1: # If block: f = g + h
    add $s0, $s1, $s2   # f = g + h

L2: # End
```

3. Fill in the cells

#table(
  columns: (auto, auto, auto, auto, auto),
  fill: (col, row) => if row == 0 { gray.lighten(50%) },
  align: center + horizon,
  table.header([], [1. Arithmetic], [2. Load], [3. Store], [4. Branch]),
  [Registers], [✓], [✓], [✓], [✓],
  [ALU], [✓], [✓], [✓], [✓],
  [Data Memory], [x], [✓], [✓], [x],
  [Control Unit], [✓], [✓], [✓], [✓],
  [PC], [✓], [✓], [✓], [✓],
)
