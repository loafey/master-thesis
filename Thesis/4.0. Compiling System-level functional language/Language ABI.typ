#import "../Prelude.typ": todo,drawStack

== Language ABI 
#text(fill: red)[As SLFL is a systems level language, there is importance in specifying an
#todo("very rough cut!! kinda garbonzo")
Application Binary Interface (ABI) #todo("Alltid viktigt med en ABI?"). 
The ABI specifies how functions and data types
are accessed and the calling conventions of said functions.

#text(fill: blue)[As opposed to most languages, SLFL has quite a special setup when it comes to 
its stacks.] As said before, the language operates using multiple stacks, 
outside of the normal stack given the operating system.
For clarity's sake the normal stack given
by the operating system will be refered to as the system stack.

The language operates in a similar manner to stack-machine based languages,
where stacks are used for capturing variables, passing variables between 
functions and calculations.  
Only one stack is in use at a time, and a stack should only be pushed to and popped from
if it is the currently used one. Mutating or reading other stacks is undefined behavior.

As the language strictly uses continuation passing style (CPS) for function calls,
and that all arguments to functions are passed along with stacks, the language
makes heavy use of tail call optimization.
Every call simply resets the stack frame, and during normal executing flow only one stack frame is ever used.

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
]