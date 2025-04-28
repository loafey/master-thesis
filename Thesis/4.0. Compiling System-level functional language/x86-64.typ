#import "../Prelude.typ": drawStack
#import "figures.typ": *

== Compilation Target
When picking a compilation target there are always a lot of options, and for SLFL,
x86-64 was picked. While choices like LLVM IR provide a lot of benefits to the developer
in terms of development speed and convience, one 
ultimately sacrifices some control over the calling convention or memory allocation.
Due to SLFL's CPS nature, tail call optimization is a must and while LLVM provides 
tools and syntax for this a developer can not guarantee how the stack is handled when
functions are called nor how arguments are
passed to these functions. For this explicit need of control x86-64 was a fitting choice.

Utilizing the flexibity given by x86-64, SLFL gains a lot of control over how the calling 
convention is implemented and how the stack, registers and memory in general is used.
In other words, it gives us the ability to have complete control over
the languages Application Binary Interface (ABI). See @languageAbiChapter
for details about that.

Similarily to other languages SLFL uses stack frames for function calls, 
but unlike other languages, SLFL only uses one during normal execution.
This is possible due to the finegrained control x86-64 gives a developer 
and the fact that SLFL strictly uses CPS.
Every function call is tail call optimized as they always end 
with calling the next function.

#v(0.5cm)
#x86withoutTailCall<x86withoutTailCall>
#v(0.5cm)
#x86withTailCall<x86withTailCall>
#v(0.5cm)
As can be seen in @x86withoutTailCall and @x86withTailCall, when using tail call optimization
the last stack frame is simply replaced frame. This optimizations is however not 
guaranteed when calling functions using 
Foreign Function Interfaces (FFI) calls, as the function that 
is being called might allocate stack frames. While FFI
is not exposed to the user, it is still used internally at the time of writing, 
as LIBC is used for printing and allocating memory on the heap.

#grid(
  columns: (1fr,0.8fr), 
  gutter: 0.5cm, [
    The single stack frame is used for variable storage and register spilling,
    and it's size is determined at compile time and can vary between functions. 
    This size is based on the amount of variables used by the function,
    and does not account for register spilling as pushing and popping handles
    stack frame size dynamically, as it updates the stack pointer accordingly. 
  ], 
  singleStackFrame
)
