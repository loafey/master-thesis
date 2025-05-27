#import "../Prelude.typ": *

== Language ABI <languageAbiChapter>
As with any language, one should define an Application Binary Interface (ABI).
#ln defines it's own datatype allocation strategy and calling convention.
As said before in @CompilingCompilationTarget, #ln only uses one stack frame during
normal execution which is used for variable storage and register spilling.
This stack frame is located on the stack given by the operating system, which will be referred
to as the system stack henceforth, and outside of this system stack,
#ln makes heavy use of other stacks.
These stacks are used for passing variables and all calculations.
This stack usage is similar in nature to the Java Virtual Machine @JavaOracle or
WebAssembly @WASMhaas2017bringing, which also makes heavy use of stacks
and virtual registers stored on the system stack.

It is worth to noting that this specification is not final, as it is with
most languages, and may be subject to change in the future if need be!

=== Function calls
When functions are called these are the requirements that must be fulfilled:
#indent[
  - Register `R15`(`SP`) is set to an address which points to a valid stack.
  - The address in `R15`(`SP`) must be a multiple of 8 (4 on a 32 bit system).
  - The stack size should be big enough for all variables in the function.
  - When the stack is empty, the origin pointer for the stack should be equal to
    the address subtracted with the stack's size.
  - All expected arguments exist on the stack.
  - All arguments are properly aligned.
  - The bottom of the stack contains the start pointer of the stack.
]

At any given moment only one stack is in use, which means that while
other stacks can be allocated and freed, and variables can only be pushed on the
current one. Mutating or reading other stacks is undefined behavior.

All functions in #ln are called through jumps(with some discrepancies
for top-level functions and FFI). This is implemented by passing around all
functions as values on the stack.
Top-level functions however work differently, and works in a somewhat similar manner
to how functions work in most other languages. There is one major difference however.
A top-level function does not actually execute the function,
and it instead pushes a code pointer onto the current stack
and returns. This code pointer points to the actual function which can then be popped
and called when need be.
In this manner top-level functions act much more like constants.

When FFI calls occur, such as calling a libc function like `printf`,
this function will allocate a stack frame on top of the single stack frame, and execute like
it would normally do. The result will then be written into a fitting register
or variable on the system stack, or it will be pushed onto the current stack.
This and along with top-level functions,
are the only time #ln strays from the strict continuation based style.

=== Mapping types to memory<mappingMemToType>
An important part of any ABI is specifying types are represented.
The following chapter specifies how much memory the types in #ln uses, and the amount
of how many physical registers are needed to store them. Keep in mind that while the ABI
does not utilize registers at the moment, this may change in the future, hence why
we define the needed amount of physical registers.

In the table `Word` represents 8 bytes, and #sym.infinity is a memory section of
unknown length, only used to represent the sizes of stacks. A more detailed explanation
of #sym.infinity can be found in @MemoryAlignment.


#let fatone = math.bold[1]
#let fatzero = math.bold[0]
#let reg(x) = $#sem(x)^"REG"$
#let mem(x) = $#sem(x)^"MEM"$
#let eq(name, eq, a, b) = block(
  breakable: false,
  table(
    fill: (x, y) => if (x == 0 and calc.rem(y, 2) == 0) { rgb("#00000010") } else { white },
    columns: (1.01fr, 1fr),
    stroke: 0.3pt,
    inset: (x, y) => if (calc.rem(y, 2) != 0) {
      (top: 10pt, left: 4pt, bottom: 10pt)
    } else {
      6pt // (top: 10pt, left: 4pt, bottom: 10pt)
    },
    ..(table.cell(colspan: 2, align(center, name)), $#reg(eq) = #a$, $#mem(eq) = #b$),
  ),
)
#grid(
  // gutter: 4pt,
  eq([Product-type], $A times.circle B: omega$, $1$, $#mem($A$) + #sym.infinity$),
  eq(
    [Product-type],
    $A times.circle B: known$,
    $\ quad quad #reg($A$) + #reg($B$)$,
    $\ quad quad #mem($A$) + #mem($B$)$,
  ),
  eq([Sum-type], $A plus.circle B: omega$, $1$, $#`Word` \ quad quad + max(mem(A), mem(B)) + #sym.infinity$),
  eq(
    [Sum-type],
    $A plus.circle B: known$,
    $\ quad quad 1 + max(reg(A), reg(B))$,
    $#`Word` \ quad quad + max(mem(A), mem(B))$,
  ),
  eq([Static function], $*A: known$, 1, `Word`),
  eq([Linear closure], $not A: known$, 1, `Word`),
  eq([Stack closure], $~A: omega$, 1, `Word`),
  eq([Linear pointer], $square A: known$, 1, `Word`),
  eq([Empty stack], $circle: omega$, 1, `Word`),
  eq([Unit], $fatone: known$, 0, 0),
  eq([Empty], $fatzero: known$, 0, 0),
  eq([#$exists$ intro], $exists alpha. A : known$, reg($A$), mem($A$)),
  eq([#$exists$ intro], $exists alpha. A : omega$, reg($A$), mem($A$)),
  eq([Type variable], $alpha : omega$, 0, 0),
)

Outside of these types, #ln contains an auxiliary type: a word sized integer.
The memory specification of integer is the following:
#eq([Integer], $int$, 1, `Word`)


=== Memory alignment<MemoryAlignment>
At the time of writing, #ln does not contain that many different types,
and currently it is limited to integers, function pointers, stack pointers,
and product- and sum-types.

Memory wise, the simplest here are function pointers and stack pointers.
Both of these are simply the size of a word, i.e 8 bytes on x86-64, and
they can always fit in a register and thus never need to be split up across multiple
registers when working with them.

Integers are currently also simple, as they are also the size of a word.
This may however change in the future as it is useful to have access to
integers of different sizes, especially so when working with a systems-level language.
When these are introduced, memory alignment is something
that needs to be taken into consideration. Function pointers and stack pointers
are stored the exact same way as word sized integers.

When pushing values of different sizes alignment needs to be considered.
Take this stack that just contains a 16 bit integer with the value `42`.

#[
  #let f(type: "normal", size, body) = table.cell(
    fill: if type == "pad" {
      rgb("#edf064")
    } else if type == "sp" {
      rgb("#ff7bcc")
    } else if type == "inf" {
      orange
    } else if type == "tag" {
      lime
    } else if type == "cons" {
      aqua
    } else {
      none
    },
    colspan: size,
    body,
  )

  #let rep(int, val) = {
    let res = ()
    for value in range(0, int) {
      (val,) + res
    }
    res
  }
  #let b(content) = box(stroke: black, width: 100%, inset: 6pt, content)
  #set table.cell(align: center)
  #let len = 16
  #let start = 45

  #table(
    columns: rep(len, 1fr),
    ..range(start, start + len).rev().map(a => raw(str(a, base: 16))),
    f(type: "tag", 2, `$42`), f(14, [...]),
  )

  #[
    Now if we want to push another value, say a 32 bit integer with the value `777`,
    we need to pad it so the value is placed on an address which is divisible by its size.
  ]
  #table(
    columns: rep(len, 1fr),
    ..range(start, start + len).rev().map(a => raw(str(a, base: 16))),
    f(type: "tag", 2, `$42`), f(type: "pad", 6, `padding`),
    f(type: "tag", 4, `$777`), f(4, type: "pad", `padding`)
  )
  #[
    As can be seen we are padding by 6. Theoretically we only need to pad by
    2 bytes here for a 4 byte integer, as 4 is of course divisible by 2.
    The reason this is done is to both to simplify the compilation process,
    and to simplify the needed code for any given pop and push.

    Also, as can bee seen in the illustrations, the addresses grow downwards.
    System stacks on most architectures grow downwards, and the dynamic stacks
    in #ln simulate this as well. This is done to allow an implementation of
    the language to use the system stack if need be, and use the built in
    pop and push instructions which exists in most instruction sets.

    Notice here that we are also padding after the 4 byte integer.
    A pop/push should always be able to expect that it is currently
    aligned, and this is done to minimize the amount of instructions
    needed when interacting with the stack. If a function is called through FFI
    for instance, it has no way of knowing if the stack pointer
    is currently aligned, unless it explicitly checks the current
    stack pointer and manually aligns.
    This would be a waste of computation time, and for this reason,
    all pushes pad to make sure that the next stack location is
    in an address divisible by 8 (would be 4 on a 32-bit platform).

    The reason padding is needed is simply because a lot of computer architectures
    assume that memory is stored in an aligned way. If a value consists of 8 bytes,
    it needs to be stored on an address divisible by 8, if its 4 bytes, the address needs
    to be divisible by 4, and so on and so forth. While x86-64 allows
    unaligned memory interactions for some instructions, this is often heavily
    discouraged because it can potentially harm performance, as it can
    require more clock cycles, and cache friendliness of the values being interacted with.
  ]

  The memory layout for product- and sum-types is also relatively simple.
  When we put a sum-type value such as `inl 42` on the stack it looks like this:

  #table(
    columns: rep(len, 1fr),
    ..range(start, start + len).rev().map(a => raw(str(a, base: 16))),
    f(type: "tag", 8, `$42`), f(type: "cons", 8, `0`),
  )

  and similarly if we put the value `inr 777` on the stack, it will look like this:

  #table(
    columns: rep(len, 1fr),
    ..range(start, start + len).rev().map(a => raw(str(a, base: 16))),
    f(type: "tag", 8, `$777`), f(type: "cons", 8, `1`),
  )
  Observe here that the tag is put on the right most position, i.e at the top of the stack,
  and that the tag is 8 bytes.

  Almost the same goes for product-types, so for a value such as `(1, 2)` we simply put them after one another:
  #table(
    columns: rep(len, 1fr),
    ..range(start, start + len).rev().map(a => raw(str(a, base: 16))),
    f(type: "tag", 8, `$1`), f(type: "tag", 8, `$2`),
  )

  For a more complex value such as `(1,(2,3))` it would look like this:
  #table(
    columns: rep(len, 1fr),
    ..range(start, start + len).rev().map(a => raw(str(a, base: 16))),
    f(type: "tag", 8, `$1`), f(type: "tag", 8, `$2`),
    ..range(0x1d, 0x2d).rev().map(a => raw(str(a, base: 16))),
    f(type: "tag", 8, `$3`), f(8, [...]),
  )
  As can be seen no information outside of the actual values is stored.

  Similar alignment should be done when storing variables on the system stack,
  but this is not enforced by this ABI, as the system stack is
  not used when passing variables.

  In @mappingMemToType some more complicated types be seen, specifically some
  types involving #sym.infinity. Take $A times.circle B: omega$ for instance, which memory usage is calculated as such: $#mem($A$) + #sym.infinity$. Here $A$ is a variable with the kind
  $known$ and $B$ is a stack with kind $omega$. Visually this would be represented like this
  (if #mem($A$) = 8):
  #block(
    breakable: false,
    table(
      columns: rep(len, 1fr),
      table.cell(colspan: 8, `...`),
      ..range(start, start + 8).rev().map(a => raw(str(a, base: 16))),
      f(type: "inf", 8, sym.infinity), f(type: "tag", 8, $A$),
    ),
  )
  This just means that $B$ is a stack of unknown size, but we at least know that
  _on top_ $B$ there are 8 bytes dedicated to a value of type $A$.
  Without $A$, $B$ could potentially be empty, or it could be huge, but we cannot know
  from the types alone.

  When allocating new stacks the first value on the stack must be the pointer
  which points to the start of the stack. As said earlier, stacks grow downwards,
  and thus their pointers need to be offset by their size on allocation.
  This however creates to problem as we can not deallocate using this updated pointer,
  and we need to instead use the original pointer. To combat this
  the original pointer is placed on the stack, which can then be popped
  when the stack is empty and `freestack` is called.
  #block(
    breakable: false,
    table(
      columns: rep(len, 1fr),
      ..range(start, start + len).rev().map(a => raw(str(a, base: 16))),
      f(type: "sp", 8, `start pointer`), f(8, `...`),
    ),
  )
]

