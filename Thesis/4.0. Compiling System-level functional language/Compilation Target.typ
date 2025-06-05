#import "../Prelude.typ": drawStack
#import "figures.typ": *

== Compilation Target<CompilingCompilationTarget>
When picking a compilation target there are always a lot of options, and for #ln,
x86-64 was picked. While choices like LLVM IR provide a lot of benefits to the developer
in terms of development speed and convenience, one
ultimately sacrifices some control over things like the calling convention and memory allocation.
Due to #ln's CPS nature, tail call optimization is a must. Languages like LLVM IR, provide
tools and syntax for this, but a developer can not guarantee how the stack is handled when
functions are called, nor how arguments are passed to these functions.
For this explicit need of control x86-64 was determined to be a fitting choice.

Utilizing the flexibility given by x86-64, #ln gains a lot of control over how the calling
convention is implemented and how the stack, registers, and memory in general is used.
In other words, it gives us the ability to have complete control over
the language's application binary Interface (ABI). See @languageAbiChapter
for details about the ABI.

Similarly to other languages #ln uses stack frames for function calls,
but unlike other languages, #ln only uses one stack frame during normal execution.
This is possible due to the fine grained control x86-64 gives a developer
and the fact that #ln is written in CPS.
Every function call can be tail-call optimized, because the sequence of commands in a
function is terminated by a function call.

#v(0.5cm)
#x86withoutTailCall<x86withoutTailCall>
#v(0.5cm)
#x86withTailCall<x86withTailCall>
#v(0.5cm)
As can be seen in @x86withoutTailCall and @x86withTailCall, when using tail-call optimization
the last stack frame is simply replaced by the new frame. This optimization is however not
guaranteed when calling functions using
Foreign Function Interfaces (FFI) calls, because the function that
is being called might allocate stack frames. While FFI
is not exposed to the user, it is still used internally at the time of writing,
because libc is used for printing and allocating memory on the heap.

#singleStackFrame

The single stack frame is used for variable storage and register spilling
#footnote[
  Register spilling means backing up a register
  on the stack, freeing the register temporarily.
],
and its size is determined at compile time and can vary between functions.
This size is based on the amount of variables used by the function,
and does not account for register spilling because pushing and popping updates
stack frame size dynamically.
