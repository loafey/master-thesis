#import "Prelude.typ": todo, stack

= Language Specification
== Language ABI 
As SLFL is a systems level language, there is importance in specifying an
#todo("very rough cut!! kinda garbonzo")
Application Binary Interface (ABI) #todo("Alltid viktigt med en ABI?"). 
The ABI specifies how functions and data types
are accessed and the calling conventions of said functions.

As opposed to most languages, SLFL has a intricate setup when it comes to the 
stack setup. As said before, the language uses multiple stacks, 
similiarly to a stack machine, and for clarity the normal stack given by the operating system
will be refered to as the system stack.

The language strictly uses continuation passing style (CPS) for function calls,
and all arguments to functions are passed along with stacks. 
This comes with the benefit of the language only needing one normal stack frame
on the system stack during normal execution flow.

#grid(columns: (1fr,0.8fr), gutter: 0.5cm, [
    The single stack frame is used for variable storage and register spilling,
    and its base size is determined at compile time and varies between functions. 
    This size is based on the amount of variables used by the function,
    and does not account for register spilling as pushing and popping handles
    stack frame size dynamically, as it updates the stack pointer accordingly. Variables are reached using the stack base pointer as the offset.
], figure(kind: image, stack(
    [],             [`a`    ],[`0x40`],
    [],             [`b`    ],[`0x38`],
    [spilling $->$],[ ..... ],[`0x30`],
), caption: [
    A system stack containing the variables `a` and `b`,
    and any spilling will occur in address space `0x30` and below.
]))

When FFI calls #todo([introduce]) occur, such as calling a LIBC function like `printf`,
this function will allocate a stack frame on top of the singular frame, and execute like
it would normally do. The result will then be written into a fitting register 
or variable on the system stack, or it will be pushed onto the current stack.

Top level functions work somewhat differently compared to how they work in other languages.
Instead of executing the function, calling a top level function pushes
a code pointer to the actual function onto the current stack.
In this sense, they are more like constants as opposed to traditional functions, 
and this is amplified by the fact that these functions are not written using CPS.
A caller simply calls the top level function to get a reference to it, 
and then executes when the time is right.
This means that there is a two-step process to calling top-level functions, 
but allows for functions to be handled like any other value.
