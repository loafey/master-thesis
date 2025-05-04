#import "../Prelude.typ": todo, drawStack, indent, bigTodo

== Language ABI <languageAbiChapter>
As with any language, one should define a Application Binary Interface (ABI).
SLFL defines it's own data type allocation strategy and calling convention.
As said before in @CompilingCompilationTarget, SLFL only uses one stack frame during
normal execution which is used for variable storage and register spilling.
This stack frame is located on the stack given by the operating system, which will be refered
to as the system stack henceforth, and outside of this system stack,
SLFL makes heavy use of other stacks.
These stacks are used for passing variables and all calculations.
This stack usage is similar in nature to the JVM#todo[source] or
WebAssembly #todo[source :)], which also makes heavy use of stacks
and virtual registers stored on the system stack.

=== Function calls
When functions are called there are requirements regarding these stacks that must be fulfilled:
#indent(12)[
  - Register `R15` is set to an address which points to a valid stack.
  - The address in `R15` must be a multiple of 8 (4 on a 32 bit system).
  - The stack size should be big enough for all variables in the function.
  - When the stack is empty, the origin pointer for the stack should be equal to
    the address subtracted with the stack's size.
  - Only one stack is in use at a given moment.
  - All expected arguments exist on the stack.
  - All arguments are properly aligned.
]

At any given moment only one stack is in use, which means that while
other stacks can be allocated and freed, and variables can only be pushed on the
current one. Mutating or reading other stacks is undefined behavior.

All functions in SLFL are called through jumps(with some discrepancies
for top-level functions and FFI). This is implemented by passing around all
functions as values on the stack.
Top-level functions however work differently, and works in a somewhat similar manner
to how functions work in most other languages. There is one major difference however.
A top-level function does not actually execute the function,
and it instead pushes a code pointer onto the current stack#todo[skulle vi ändra detta?]
and returns. This code pointer points to the actual function which can then be popped
and called when need be.
In this manner top-level functions act much more like constants.

When FFI calls #todo([introduce]) occur, such as calling a LIBC function like `printf`,
this function will allocate a stack frame on top of the single stack frame, and execute like
it would normally do. The result will then be written into a fitting register
or variable on the system stack, or it will be pushed onto the current stack.
This and along with with top-level functions,
are the only time SLFL strays from the strict continuation based style.

=== Memory layout
As the time of writing, SLFL does not contain that many different types,
and currently it is limited to integers, function pointers, stack pointers,
and product- and sum-types.

Memory wise, the simplest here are function pointers and stack pointers.
Both of these are simply the size of a word, i.e 8 bytes on x86-64, and
they can always fit in a register and thus never need to be split up accross multiple
registers when working with them.

Integers are currently also very simple, as they are also the size of a word.
This might however change in the future as it is useful to have access to
integers of different sizes, especially so when working with a systems-level language.
When these are introduced, memory alignment is something
that needs to be taken into consideration.


#bigTodo[Yoinka lite fina tabeller från mina notes #emoji.bread]
