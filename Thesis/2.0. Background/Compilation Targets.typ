#import "../Prelude.typ": todo

== Compilation Targets
When you are compiling your language you have to pick a target to compile it to.
Unless you are directly targeting binary machine code, most of the time
you want a more higher level compilation target.

There are a lot of different fitting choices for this task and some of the more
commons ones are for example LLVM IR#todo("source"), Cranelift #todo("source") and GNU's
GENERIC and GIMPLE #todo[source]. These languages are what is known as
intermediate representations (IR), and are all targeted by different compilers.
They remove the need for the compilers to directly target
CPU specific machine code or assembly.
Most of the time these IRs are also cross platform, giving compilers
portability if need be.
As these languages are higher level compared to an assembly language,
it of course comes with the cost of removing some control.

Depending on the source language you are compiling a lot of these IRs
might not necessarily be the most fitting choices.
A lot of these are modelled for imperative languages, and expect
the source language to follow a traditional stack frame based calling convention,
which might not always be the most fitting choice.
For these case, it might be nicer to target an assembly language directly instead.

An assembly language is often as low as you can go without directly targeting
machine code, and it is often made to resemble CPU instructions
relatively closely. x86-64 is currently the most used instruction set in CPUs for
personal computers and server architectures,
and it is an extension that was created in 2000 based on the already popular
instruction set x86.

When you directly target an assembly language portability suffers as is to
be expected. You not only have to target different assembly languages
for different CPU architectures, you will also have to cater to the operating system
you are targeting. For instance, on a \*nix operating system, you can almost
always rely upon some implemention of libc, be it glibc or musl,
or system calls if more power is needed, while on Windows you have to instead
depend on the provided libraries to interact with the rest of the system.
A simple act such as printing might look wildly different
depending on the operating system because even though they might use the same
assembly language, they can involve extremely different calls to the operating system.
This is something you have to consider with most IRs as well, but it can
be alleviated with sufficient abstractions.
