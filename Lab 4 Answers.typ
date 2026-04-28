#set page(paper: "a4", margin: 2cm)

#align(right)[De Montfort University Cambodia]

= CTEC1704 – LAB 4 (Answers)

== COMPUTER SYSTEM: FOUNDATION

+ *What is hardware?* \
  Hardware refers to the physical, tangible parts of a computer system, such as
  the motherboard, CPU, RAM, storage drives, and peripheral devices like
  keyboards and monitors.

+ *What is clock speed measured in?* \
  It is measured in Hertz (Hz), commonly in gigahertz (GHz) for modern
  processors.

+ *List the components of the central processing unit (CPU)* \
  The main components are the Control Unit (CU), the Arithmetic and Logic Unit
  (ALU), and registers.

+ *Which central processing unit (CPU) component makes logical decisions?* \
  The Arithmetic and Logic Unit (ALU).

+ *What is a register?* \
  A register is a small, extremely fast storage location within the CPU used to
  hold data, instructions, or memory addresses currently being processed.

+ *What is a core?* \
  A core is an individual processing unit within a CPU. A multi-core processor
  has multiple independent cores that can execute instructions simultaneously,
  improving performance.

+ *What are the three types of bus?* \
  The address bus, the data bus, and the control bus.

+ *Which of these statements about Von Neumann architecture is true?* \
  Data and instructions are both stored in main memory.

+ *Which register holds the address of the next instruction to be fetched from
  memory?* \
  The Program Counter (PC).

#pagebreak()

== COMPUTER ARCHITECTURE

+ *List 8 Great Ideas in Computer Architecture and explain each one.* \
  #set enum(numbering: "1.")
  1. Design for Moore’s Law.
  2. Use abstraction to simplify design.
  3. Make the common case fast.
  4. Performance via parallelism.
  5. Performance via pipelining.
  6. Performance via prediction.
  7. Hierarchy of memories.
  8. Dependability via redundancy.

+ *What is the purpose of the CPU?* \
  The CPU acts as the "brain" of the computer, responsible for fetching,
  decoding, and executing program instructions, as well as performing
  calculations and coordinating the activities of other components.

+ *What does the control unit do?* \
  It coordinates and directs the operations of the processor by decoding
  instructions and issuing control signals to other components to manage data
  flow.

+ *What is the immediate access store for?* \
  Also known as main memory or RAM, it is used for fast, temporary storage of
  data and instructions currently being used by the CPU.

+ *What does the arithmetic and logic unit do?* \
  It performs all mathematical operations and logical operations (such as
  comparisons) on data.

+ *What can often be referred to as the registers in a CPU?* \
  They are often called the "fastest memory" in the computer, or sometimes
  "internal storage" within the CPU.

+ *How many instructions can a CPU process at a time?* \
  Generally, a single CPU core processes one instruction at a time, though
  advanced architectures use techniques like pipelining and superscalar
  execution to handle parts of multiple instructions simultaneously.

+ *What is it called when the CPU carries out the action of an instruction?* \
  The "Execute" phase (part of the overall fetch-decode-execute cycle).

+ *What is clock speed measured in?* \
  Hertz (Hz), typically gigahertz (GHz) for modern processors.

+ *How many cycles per second would a 3 GHz processor do?* \
  3 billion cycles per second.
