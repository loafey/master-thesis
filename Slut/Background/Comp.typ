#import "../Prelude.typ": *

== How are programs represented on computers?
Little bit about assembly, very simple

Introducera stacken, och register

Berätta varför det är så jobbigt att jobba med

Berätta hur vi vill förbättra detta ur syftet av funktionella språk

#pagebreak()

#let program = i => {
  let string = "PUSH $1
PUSH $2
PUSH $3
POP  %AX
MOV  -0x10(%BP), %BX
ADD  %AX, %BX
PUSH %BX"
  let newString = ""
  let count = 0
  for line in string.split("\n") {
    let pre = if count == i { "➙ " } else { "  " }
    newString += pre + line + "\n"
    count += 1
  }
  raw(lang: "asm", newString)
};
#let regs = (a, b) => [AX = #a,\ BX = #b];
#(pre.anim)(
  [
    When programming the rawest control you can get is by using assembly code.

    Lets you directly interact with the computer using CPU instructions.
  ],
  (
    grid(
      columns: (1fr, 1fr, 1fr),
      program(-1),
      regs(0, 0),
      drawStack(
        ..([$S P \& B P ->$], [_empty_], [`0x30`]),
        ..([], [_empty_], [`0x20`]),
        ..([], [_empty_], [`0x10`]),
        ..([], [_empty_], [`0x00`]),
      ),
    ),
    grid(
      columns: (1fr, 1fr, 1fr),
      program(0),
      regs(0, 0),
      drawStack(
        ..([$S P \& B P ->$], [_empty_], [`0x30`]),
        ..([], [_empty_], [`0x20`]),
        ..([], [_empty_], [`0x10`]),
        ..([], [_empty_], [`0x00`]),
      ),
    ),
    grid(
      columns: (1fr, 1fr, 1fr),
      program(1),
      regs(0, 0),
      drawStack(
        ..([$B P ->$], [`$1`], [`0x30`]),
        ..([$S P ->$], [_empty_], [`0x20`]),
        ..([], [_empty_], [`0x10`]),
        ..([], [_empty_], [`0x00`]),
      ),
    ),
    grid(
      columns: (1fr, 1fr, 1fr),
      program(2),
      regs(0, 0),
      drawStack(
        ..([$B P ->$], [`$1`], [`0x30`]),
        ..([], [`$2`], [`0x20`]),
        ..([$S P ->$], [_empty_], [`0x10`]),
        ..([], [_empty_], [`0x00`]),
      ),
    ),
    grid(
      columns: (1fr, 1fr, 1fr),
      program(3),
      regs(0, 0),
      drawStack(
        ..([$B P ->$], [`$1`], [`0x30`]),
        ..([], [`$2`], [`0x20`]),
        ..([], [`$3`], [`0x10`]),
        ..([$S P ->$], [_empty_], [`0x00`]),
      ),
    ),
    grid(
      columns: (1fr, 1fr, 1fr),
      program(4),
      regs(`$3`, 0),
      drawStack(
        ..([$B P ->$], [`$1`], [`0x30`]),
        ..([], [`$2`], [`0x20`]),
        ..([$S P ->$], [`$3`], [`0x10`]),
        ..([], [_empty_], [`0x00`]),
      ),
    ),
    grid(
      columns: (1fr, 1fr, 1fr),
      program(5),
      regs(`$3`, `$2`),
      drawStack(
        ..([$B P ->$], [`$1`], [`0x30`]),
        ..([], [`$2`], [`0x20`]),
        ..([$S P ->$], [`$3`], [`0x10`]),
        ..([], [_empty_], [`0x00`]),
      ),
    ),
    grid(
      columns: (1fr, 1fr, 1fr),
      program(6),
      regs(`$3`, `$5`),
      drawStack(
        ..([$B P ->$], [`$1`], [`0x30`]),
        ..([], [`$2`], [`0x20`]),
        ..([$S P ->$], [`$3`], [`0x10`]),
        ..([], [_empty_], [`0x00`]),
      ),
    ),
    grid(
      columns: (1fr, 1fr, 1fr),
      program(7),
      regs(`$3`, `$5`),
      drawStack(
        ..([$B P ->$], [`$1`], [`0x30`]),
        ..([], [`$2`], [`0x20`]),
        ..([], [`$5`], [`0x10`]),
        ..([$S P ->$], [_empty_], [`0x00`]),
      ),
    ),
  ),
)

There are also instructions such as:

#indent[
  - `jmp` - unconditional jump
  - `je` - jump if two values are equal
  - `call` - subroutine call
  - `ret` - return from a subroutine
]

These lets us implement control flow.

== Problem with using this
Very verbose, and hard to write large programs!

Hard to debug if something goes wrong.

Lacks some much needed abstractions!
