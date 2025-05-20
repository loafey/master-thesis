#import "../Prelude.typ": *

== Language ABI <languageAbiChapter>
As with any language, one should define a Application Binary Interface (ABI).
#ln defines it's own data type allocation strategy and calling convention.
As said before in @CompilingCompilationTarget, #ln only uses one stack frame during
normal execution which is used for variable storage and register spilling.
This stack frame is located on the stack given by the operating system, which will be refered
to as the system stack henceforth, and outside of this system stack,
#ln makes heavy use of other stacks.
These stacks are used for passing variables and all calculations.
This stack usage is similar in nature to the JVM#todo[source] or
WebAssembly #todo[source :)], which also makes heavy use of stacks
and virtual registers stored on the system stack.

It is worth to noting that this specification is not final, as it is with
most languages, and may be subject to change in the future if need be!

=== Function calls
When functions are called there are requirements regarding these stacks that must be fulfilled:

#indent[
  - Register `R15`(`SP`) is set to an address which points to a valid stack.
  - The address in `R15`(`SP`) must be a multiple of 8 (4 on a 32 bit system).
  - The stack size should be big enough for all variables in the function.
  - When the stack is empty, the origin pointer for the stack should be equal to
    the address subtracted with the stack's size.
  - All expected arguments exist on the stack.
  - All arguments are properly aligned.
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
and it instead pushes a code pointer onto the current stack#todo[skulle vi ändra detta?]
and returns. This code pointer points to the actual function which can then be popped
and called when need be.
In this manner top-level functions act much more like constants.

When FFI calls #todo([introduce]) occur, such as calling a libc function like `printf`,
this function will allocate a stack frame on top of the single stack frame, and execute like
it would normally do. The result will then be written into a fitting register
or variable on the system stack, or it will be pushed onto the current stack.
This and along with with top-level functions,
are the only time #ln strays from the strict continuation based style.
=== Mapping types to memory
An important part of any ABI is specifying types are represented.
The following chapter specifies how much memory the types in #ln uses, and also the amount
of how many physical are registers needed to store them. Keep in mind that while the ABI
does not utilize registers at the moment, this might change in the future.

In the table `Word` represents 8 bytes, and #sym.infinity is a memory section of
unknown length, only used to represent the sizes of stacks.

#let type_judgements(show_note) = {
  positive(show_note)
  linebreak()
  negative(show_note)
}

#let fatone = math.bold[1]
#let fatzero = math.bold[0]
#let reg(x) = $#sem(x)^"REG"$
#let mem(x) = $#sem(x)^"MEM"$
#let eq(name, eq, a, b) = block(
  breakable: false,
  table(
    columns: (1.01fr, 1fr),
    stroke: 0.3pt,
    inset: (top: 10pt, left: 4pt, bottom: 10pt),
    ..(table.cell(colspan: 2, align(center, name)), $#reg(eq) = #a$, $#mem(eq) = #b$),
  ),
)
#grid(
  gutter: 4pt,
  eq([Product-type], $A times.circle B: omega$, $1$, $\ quad quad #mem($A$) + #mem($B$) + #sym.infinity$),
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
  eq([Top], $fatone: known$, 0, 0),
  eq([Bot], $fatzero: known$, 0, 0),
  eq([#$exists$ intro], $exists alpha. A : known$, reg($A$), mem($A$)),
  eq([#$exists$ intro], $exists alpha. A : omega$, reg($A$), mem($A$)),
  eq([Type variable], $alpha : omega$, 0, 0),
)

=== Memory alignment
#text(red)[
  As the time of writing, #ln does not contain that many different types,
  and currently it is limited to integers, function pointers, stack pointers,
  and product- and sum-types.
  Important to note that both the system stack, and any stacks which are created
  dynamically, grow downwards.
]#todo[rewrite]

Memory wise, the simplest here are function pointers and stack pointers.
Both of these are simply the size of a word, i.e 8 bytes on x86-64, and
they can always fit in a register and thus never need to be split up accross multiple
registers when working with them.

Integers are currently also simple, as they are also the size of a word.
This might however change in the future as it is useful to have access to
integers of different sizes, especially so when working with a systems-level language.
When these are introduced, memory alignment is something
that needs to be taken into consideration. Function pointers and stack pointers
are the stored the exact same way as word sized integers.

When pushing values of different sizes alignment needs to be considered.
Take this stack that just contains a 16 bit integer with the value `42`.

#[
  #let f(type: "normal", size, body) = table.cell(
    fill: if type == "pad" {
      rgb("#edf064")
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
    The reason this is done is to both to simpilfy the compilation process,
    and to simplify the needed code for any given pop and push.

    Notice here that we are also padding after the 4 byte integer.
    A pop/push should always be able to expect that it is currently
    aligned, and this is done to minimize the amount of instructions
    needed when interacting with the stack. If a function is called through FFI
    for instance, it has no way of knowing if the stack pointer
    is currently aligned unless it does some arithetics to calculate this,
    which would be a waste of computation time. For this reason,
    all pushes pad to make sure that the next stack location is
    in an address divisible by 8 (would be 4 on a 32-bit platform).

    The reason padding is needed is because most, if not all, computer architectures
    assume that memory is stored in an aligned way. If a value consists of 8 bytes,
    it needs to be stored on an address divisible by 8, if its 4 bytes, the address needs
    to be divisible by 4, and so on and so forth. While x86-64 allows
    unalligned memory interactions for some instructions, this is often heavily
    discouraged because it can potentially harm performance, as it potentially
    requires more clock cycles, and can hurt the memory sections cache friendlines.
    #todo[kan skrivas bättre]
  ]

  The memory layout for product- and sum-types is also relatively simple.
  When we put a sum-type value such as `inl 42` on the stack it looks like this:
  #table(
    columns: rep(len, 1fr),
    ..range(start, start + len).rev().map(a => raw(str(a, base: 16))),
    f(type: "tag", 8, `$42`), f(type: "cons", 8, `0`),
  )
  and similarily if we put the value `inr 777` on the stack, it will look like this:
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

  For a more comples value such as `(1,(2,3))` it would look like this:
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

  #bigTodo[Snacka om \ #sem($A #sym.times.circle ~B$) \ #sem($~A$) \ add JP mem size func \ add all types,

    $#sem($o$)^("REG") = "Type" -> NN$\
    $#sem($o$)^("MEM") = "Type" & -> NN\
    & \^\
    & "bytes"$
  ]
]

