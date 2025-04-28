#import "../Prelude.typ": todo

== Compilation Targets
Unless you are directly targeting binary machine code, most of the time
you want a more higher level compilation target to compile your language to.

There are a lot of different fitting choices for this task and some of the more 
commons ones are for example LLVM IR#todo("source"), Cranelift #todo("source") and GNU's 
GENERIC and GIMPLE #todo[source]. These languages are what is known as 
intermediate representations (IR), and are all targeted by different compilers.
They remove the need for the compilers to directly target
specific machine code or CPU assembly themselves.
Most of the time these IRs are also cross platform, automatically giving compilers
portability if need be. 
As these languages are higher level compared to an assembly language,
it of course comes with the cost of removing some control. 
A lot of these are however modelled for imperative language, and expect
the source language to follow the traditional stack frame based calling convention, 
which, depending on the source language, might not always be the most fitting choice.
For these case, it might be nicer to target an assembly language directly instead.

When you #todo[you] directly target an assembly language portability suffers as is to 
be expected. You not only have to target different assembly languages
for different CPU architectures, you will also have to cater to the operating system
you are targeting. For instance, on a \*nix operating system, you can almost
always rely upon some implemention of LIBC, be it GLIBC or musl, 
or system calls if more power is needed, while on Windows you have to instead
depend on the provided libraries to interact with the rest of the system.
A simple act such as printing might look wildly different 
depending on the operating system because even though they might use the same
assembly language, they can involve extremely different calls to the operating system.
#todo[detta gäller även många IR språk. LLVM IR har tex samma problem]

#text(fill: blue)[
x86-64 is currently the most used instruction set in CPUs for 
personal computers and server architectures. 
It is an extension that was created in 2000 based on the already popular 
instruction set x86.
]
